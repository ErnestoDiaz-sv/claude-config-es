# Skill `investigar`

**Propósito:** guiar la investigación de causa raíz antes de proponer un arreglo.

- **Cuándo se activa:** errores, stack traces, comportamiento inesperado o `/investigar` (descripción en `skills/investigar/SKILL.md`, línea 3).
- **Entradas:** síntoma, evidencia, código y, cuando aplica, cambios recientes, reproducción o logs de producción.
- **Salida:** hipótesis verificable, investigación, fix mínimo con regresión y reporte de verificación.
- **Ejemplo:** `/investigar` ante un error que dejó de ocurrir correctamente.
- **Límites:** no aplicar un arreglo sin verificar hipótesis; detenerse tras tres hipótesis fallidas y avisar antes de una corrección que toque más de cinco archivos.
