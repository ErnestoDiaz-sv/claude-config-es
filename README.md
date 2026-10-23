# Configuración ligera para Claude Code

Una configuración ligera para Claude Code pensada para el plan Pro: Opus toma las decisiones y coordina; subagentes más económicos ejecutan tareas acotadas; un hook de verificación opt-in corre los checks del repositorio al detenerse; y las prácticas de costo ayudan a mantener las sesiones enfocadas. No se prometen ahorros medidos.

## Contenido

| Componente | Qué incluye |
|---|---|
| `CLAUDE.example.md` | Plantilla genérica de instrucciones globales en español. |
| `settings.example.json` | Ejemplo mínimo de configuración de modelo, status line y hook. |
| `quality-bar.md` | Criterios verificables de calidad de ingeniería. |
| `statusline.sh` | Modelo y uso aproximado de contexto en la terminal. |
| `hooks/verify-on-stop.sh` | Verificación opt-in de cambios no documentales al detenerse. |
| `agents/` | Perfiles de exploración, implementación y revisión. |
| `skills/` | Guías de investigación, planificación, costos, configuración y entrega. |
| `install.sh` | Instalador que copia archivos y nunca sobrescribe existentes. |

## Instalación

Primero revisá las acciones sin escribir nada:

```bash
./install.sh --dry-run
```

Luego instalá la configuración completa con:

```bash
./install.sh
```

El destino predeterminado es `~/.claude`; se puede cambiar con `CLAUDE_HOME=/ruta`. Para instalar solo una categoría, usá `--only skills`, `--only agents` o `--only hooks`. Los archivos existentes se omiten. El instalador no modifica `settings.json`: revisá `settings.example.json` y combiná sus opciones manualmente.

## Hook Stop

El hook solo actúa en un repositorio que tenga un `scripts/check.sh` ejecutable, un `HEAD` existente y cambios sin confirmar que no sean Markdown. Si esos cambios no cambiaron desde una verificación exitosa, evita repetirla. El hook no instala ni crea `scripts/check.sh`: cada repositorio opta por participar al proveer ese script. Se puede omitir una ejecución con `CLAUDE_SKIP_VERIFY=1`.

## Créditos

Ver [NOTICE.md](NOTICE.md) para los créditos y licencias de los materiales adaptados.
