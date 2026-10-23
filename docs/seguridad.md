# Seguridad y alcance

## Qué lee y escribe cada pieza

| Pieza | Lee | Escribe o ejecuta | Lo que no hace |
|---|---|---|---|
| `install.sh` | Lista de archivos del repositorio y destinos existentes. | Crea directorios destino, copia los archivos listados y marca los `.sh` copiados como ejecutables. | No sobrescribe destinos existentes ni modifica `settings.json`. |
| `uninstall.sh` | Archivos listados y copias instaladas para compararlas byte a byte. | Elimina solo copias idénticas; `--dry-run` solo informa. | No borra archivos modificados ni toca `settings.json`. |
| `hooks/verify-on-stop.sh` | Entrada JSON por stdin, variables de entorno, estado Git, diff y contenido de archivos no rastreados no Markdown; consulta `jq` y Git. | Ejecuta `scripts/check.sh` si corresponde y, si pasa, guarda una huella en el directorio Git. | No instala checks; no actúa si faltan las condiciones opt-in; no envía datos por red. |
| `statusline.sh` | JSON por stdin, campos del modelo y del uso de contexto. | Escribe una línea en stdout. | No modifica configuración ni consulta servicios de red. |
| `scripts/check.sh` | Archivos del repositorio, metadatos Git y herramientas disponibles. | Ejecuta validadores y crea/borra un directorio temporal para integración. | No instala dependencias ni realiza llamadas de red. |

`scripts/check.sh` comprueba sintaxis de shell, usa ShellCheck si está instalado, valida JSON con `jq`, revisa metadatos, enlaces y patrones sensibles en archivos rastreados, y prueba instalación/desinstalación en ubicaciones temporales. La comprobación puede marcar falsos positivos: revisá el archivo señalado antes de cambiarlo.

## Red y permisos

Los scripts del repositorio no realizan llamadas de red. Los validadores del entorno pueden tener su propio comportamiento; instalá herramientas solo desde fuentes que confíes. Revisá los archivos y los comandos antes de instalar. Para revisar sin escribir, ejecutá `./install.sh --dry-run`. El hook debe habilitarse manualmente desde la configuración y corre con los permisos del usuario que ejecuta Claude Code.

No guardes credenciales ni archivos `.env` en el repositorio. No publiques secretos en issues, logs o ejemplos. Limitá permisos y acceso a los archivos de configuración según el uso de tu equipo.

## Auditoría antes de instalar

1. Leé `install.sh`, `scripts/list-files.sh` y los archivos que se copiarán.
2. Ejecutá el modo de prueba y confirmá que el destino sea el esperado.
3. Revisá `settings.example.json` antes de combinarlo; no reemplaces tu configuración completa.
4. Si querés retirar la instalación, usá primero `./uninstall.sh --dry-run`. Las copias modificadas se conservan y se reportan.

El reporte privado de vulnerabilidades se describe en [SECURITY.md](../SECURITY.md).
