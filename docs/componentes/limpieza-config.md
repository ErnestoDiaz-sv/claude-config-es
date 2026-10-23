# Skill `limpieza-config`

**Propósito:** proponer una limpieza revisable de configuraciones de Claude Code.

- **Cuándo se activa:** pedido de revisar qué sobra, ordenar memorias o limpiar configuración.
- **Entradas:** rutas y canales disponibles dentro de los límites descritos en `skills/limpieza-config/SKILL.md`.
- **Salida:** candidatos con evidencia; solo después de aprobación, cambios reversibles y reporte.
- **Ejemplo:** `/limpieza-config` para revisar skills o hooks huérfanos.
- **Límites:** un candidato por decisión, sin borrado irreversible no autorizado, hasta aproximadamente veinte candidatos por pasada.
