# Seguridad

## Reportar una vulnerabilidad

No publiques detalles explotables, credenciales ni datos sensibles en un issue público. Usá la función **Private vulnerability reporting** de GitHub para este repositorio. Si no está disponible, contactá en privado a los mantenedores desde el perfil de GitHub y compartí solo la información necesaria para reproducir y corregir el problema.

## Alcance

Este proyecto contiene skills, perfiles de agentes, scripts locales de instalación/verificación/desinstalación, un hook opcional y una status line para Claude Code. Los reportes relevantes incluyen ejecución inesperada de comandos, exposición de datos, comportamiento inseguro de instalación o desinstalación y problemas en el hook.

Los scripts incluidos no hacen llamadas de red. El hook corre con los permisos del usuario y puede ejecutar el `scripts/check.sh` del repositorio activo; revisá ese script antes de habilitar el hook. No envíes secretos ni información personal en reportes públicos.
