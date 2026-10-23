# Guía rápida

## Antes de empezar

El instalador copia skills, agentes, el hook y la status line a `~/.claude`. No modifica `settings.json` ni reemplaza archivos existentes. Para probar en otro destino, definí `CLAUDE_HOME`.

## Revisar e instalar

Desde la raíz de este repositorio:

```bash
./install.sh --dry-run
CLAUDE_HOME="$(mktemp -d)" ./install.sh --dry-run
./install.sh
```

El primer comando muestra las copias previstas sin escribir. El segundo muestra el mismo flujo en un destino temporal. El tercero instala en `~/.claude` (o en el valor de `CLAUDE_HOME`). Si aparece `SKIP (exists)`, ese archivo se conserva tal cual.

## Primer uso

Invocá una skill por su nombre cuando corresponda, por ejemplo `/investigar` para diagnosticar un problema o `/revisar-plan` para revisar un plan antes de programar. Los agentes se usan para tareas compatibles con sus descripciones. La instalación no activa automáticamente el hook: revisá `settings.example.json` y combiná manualmente sus entradas con tu configuración si querés habilitarlo.

## Verificar

Comprobá que las rutas esperadas existen bajo `~/.claude/skills`, `~/.claude/agents` y `~/.claude/hooks`. Para validar el repositorio de configuración y probar instalación/desinstalación en directorios temporales:

```bash
./scripts/check.sh
```

Para quitar los archivos que sigan idénticos a los del repositorio:

```bash
./uninstall.sh --dry-run
./uninstall.sh
```

La desinstalación conserva y reporta archivos modificados. Nunca toca `settings.json`; quitá manualmente cualquier referencia del hook que hayas agregado.
