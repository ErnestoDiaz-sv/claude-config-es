# Preguntas frecuentes y solución de problemas

## ¿El instalador reemplaza lo que ya tengo?

No. Informa `SKIP (exists)` y deja intacto cualquier destino existente, incluso si su contenido difiere. Revisá la instalación manualmente si querés actualizar una copia.

## ¿Cómo desinstalo?

Primero ejecutá `./uninstall.sh --dry-run` para ver qué copias idénticas quitaría; luego `./uninstall.sh`. Los archivos modificados se mantienen con el mensaje `KEPT (modified)`. Si agregaste el hook a `settings.json`, quitá esa entrada por separado: el desinstalador nunca edita ese archivo.

## ¿Cómo cambio el destino?

Definí `CLAUDE_HOME=/ruta` antes de ejecutar `install.sh` o `uninstall.sh`. El destino predeterminado es `~/.claude`.

## El hook vuelve a ejecutarse o parece entrar en un ciclo

El hook usa una huella de cambios para no repetir un check que ya pasó. Si el check falla en la primera ejecución, devuelve el error a Claude. Si el hook indica que ya se reintentó, permite detenerse y presenta un mensaje, evitando un bucle infinito. Para omitir una ejecución configurá `CLAUDE_SKIP_VERIFY=1`. También podés desactivar la entrada Stop en `settings.json`.

## ¿Por qué no se ejecutó el hook?

Debe estar configurado en `settings.json`, el proyecto debe tener un `scripts/check.sh` ejecutable y un `HEAD` existente, y debe haber cambios no Markdown sin confirmar. El hook también se omite con `CLAUDE_SKIP_VERIFY=1`.

## ¿Por qué una skill no se activa?

Invocala por su nombre, por ejemplo `/investigar`. Verificá que esté en `~/.claude/skills/<nombre>/SKILL.md` y que el contexto coincida con la descripción de activación. Una skill no se activa por cualquier mención temática.

## ¿Puedo personalizar los archivos?

Sí. Conservá una copia antes de editar. El instalador omite archivos existentes; el desinstalador identifica el contenido exacto y mantiene los archivos que cambiaste.

## `scripts/check.sh` falla por una herramienta ausente

`jq` se requiere para validar JSON. ShellCheck es opcional; si no está disponible, el check informa `SKIP shellcheck`. Instalá únicamente la herramienta que decidas usar y volvé a correr el script.
