# Registro de cambios

Este archivo sigue el formato Keep a Changelog.

## [Sin publicar]

### Añadido

- Herramientas para detectar deriva, probar el hook y documentar el mantenimiento.
- Comprobaciones de tamaño de skills y aliases de modelos, con CI reforzada.

### Cambiado

- Los agentes usan aliases de modelo (`haiku` y `sonnet`) en lugar de IDs fijados.
- `implementador` y `revisor` declaran su esfuerzo (`medium` y `high`).
- `statusline.sh` usa el tamaño real de la ventana de contexto y colorea por porcentaje.
- `supervisor-de-costos` reescrita: más corta, con tabla de agentes y reglas de esfuerzo.
- `limpieza-config` recupera los comandos concretos para medir uso, detectar hooks huérfanos y mover a la papelera.
- `office-hours` y `limpieza-config` solo se activan cuando el usuario las invoca.

## [0.1.0] - 2026-10-22

### Añadido

- Guías en español, páginas de componentes y plantillas para contribuir.
- Script de verificación del repositorio e integración continua.
- Desinstalador que conserva copias modificadas y admite modo de prueba.
