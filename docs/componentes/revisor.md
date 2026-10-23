# Agente `revisor`

**Propósito:** revisar de forma independiente cambios y verificaciones sin editarlos.

- **Cuándo se usa:** después de una implementación o para QA de una spec/plan.
- **Entradas:** tarea, requisitos y ubicación del cambio.
- **Salida:** veredicto `VEREDICTO: APROBADO` o `VEREDICTO: CAMBIOS NECESARIOS`, con hallazgos concretos.
- **Ejemplo:** pedir que contraste el diff con los criterios de aceptación.
- **Límites:** no modifica archivos; Bash queda limitado a checks de solo lectura y tests.
