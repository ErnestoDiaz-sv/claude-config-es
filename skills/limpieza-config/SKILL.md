---
name: limpieza-config
description: Limpieza periódica de una configuración de Claude Code — skills, memorias, hooks, permisos, MCP, timers y cachés que quedaron viejos, duplicados, huérfanos o contradictorios. Usar cuando el usuario pide revisar qué sobra, ordenar memorias o limpiar la configuración. Propone candidatos uno por uno con evidencia; nunca borra sin confirmación ni de forma irreversible.
disable-model-invocation: true
---

# Limpieza de config — recolección de basura con humano en el loop

Adaptado de la skill config-gc de ECC (Affaan Mustafa, MIT). La configuración
solo crece (skills, memorias, permisos); sin revisión se deteriora en silencio
y cada sesión paga por lo que se carga siempre.

## Reglas

1. **Un candidato, una decisión.** Mostrar la evidencia y preguntar sí / no /
   saltar por cada uno. Nunca "¿borro los 15?".
2. **Nada irreversible.** Mover a `~/.claude/_gc_trash/<fecha>/` (o renombrar
   a `.disabled`). Borrado real solo si el usuario lo pide explícitamente.
3. **Viejo ≠ muerto.** Algo sin uso durante 60 días puede ser de temporada.
   La edad es una señal, no un veredicto.
4. **Memorias contradictorias se fusionan leyendo las dos** y quedándose con
   la verdad más nueva — no se borra la más larga ni se trunca.
5. **No tocar:** `plugins/` (lo maneja Claude Code), directorios gestionados
   por sincronización, discos de backup, ni nada fuera de `~/.claude`,
   `~/dotfiles` o el `.claude/` de un proyecto.
6. **Máximo ~20 candidatos por pasada.** Es periódico, no exhaustivo.

## Dónde mirar (y qué delata un candidato)

Revisar las rutas disponibles para skills, agentes, hooks, configuración y
memorias, sin asumir que son symlinks ni modificar archivos fuera del alcance
aprobado.

| Canal | Ruta | Señales |
|---|---|---|
| Skills | `~/.claude/skills/*/` | Nunca invocada en transcripts recientes; se pisa con otra; dominio que ya no aplica; SKILL.md vacío o roto |
| Agentes | `~/.claude/agents/*.md` | Nadie los menciona (skills, CLAUDE.md, transcripts); duplican a otro |
| Memorias | `~/.claude/projects/*/memory/` | Marcadas STALE/HISTÓRICO/CERRADO; fechas pasadas; archivo sin línea en `MEMORY.md` o línea apuntando a archivo inexistente; contradicciones; referencias a archivos o flags inexistentes |
| Hooks | `~/.claude/hooks/` + `settings.json` | Script que ningún settings referencia; hook que apunta a script inexistente |
| Permisos | `settings.json`, `settings.local.json`, `<repo>/.claude/settings.local.json` | Duplicados; reglas específicas tapadas por un comodín; permisos de un experimento puntual |
| MCP | `claude mcp list` | No conecta; duplica a otro; sin uso en transcripts |
| Programados | `systemctl --user list-timers`, cron, rutinas programadas | Timer cuyo script ya no existe; tarea de una sola ejecución ya disparada; loop de espera innecesario |
| Cachés | `file-history/`, `debug/`, `shell-snapshots/`, `paste-cache/` | Grande y de más de 30 días. Los `.jsonl` de `projects/` son historial: solo proponer por tamaño, nunca por defecto |

Uso de skills en los transcripts (invocación por herramienta y por slash;
la lista incluye comandos nativos como `/clear`, ignorarlos):

```bash
grep -ho -e '"skill":"[^"]*"' -e '<command-name>/[^<]*' ~/.claude/projects/*/*.jsonl \
  | sed -E 's/.*"skill":"|.*<command-name>\///; s/"$//' | sort | uniq -c | sort -rn
```

Hooks huérfanos (solo lee, no cambia la configuración):

```bash
for f in ~/.claude/hooks/*; do grep -qF "$(basename "$f")" ~/.claude/settings*.json || echo "HUÉRFANO: $f"; done
```

## Flujo

1. **Escanear** los canales (o los que el usuario nombre). Buscar patrones
   antes de leer archivos enteros.
2. **Presentar** una tabla numerada ordenada por confianza (roto/huérfano
   primero, "solo viejo" al final): ruta, canal, señal, tamaño, última
   modificación.
3. **Confirmar uno por uno.** El usuario puede cortar cuando quiera.
4. **Aplicar** solo lo confirmado y dentro de las rutas permitidas:
   ```bash
   d=$(date +%F); mkdir -p ~/.claude/_gc_trash/$d
   mv <ruta> ~/.claude/_gc_trash/$d/
   echo "$(date -Is) <ruta> -> _gc_trash/$d/ — <motivo> (deshacer: mv de vuelta)" >> ~/.claude/limpieza-log.md
   ```
   - Memoria movida → sacar también su línea de `MEMORY.md`.
   - Permisos (JSON sin comentarios): copiar a `.bak`, anotar la regla
     textual en el log, quitarla con `jq`.
5. **Reportar** en 3-4 líneas: qué se movió, cuánto se liberó, qué canales
   quedaron sanos, y sugerir la próxima pasada en aproximadamente 30 días.
