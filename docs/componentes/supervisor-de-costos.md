# Skill `supervisor-de-costos`

**Propósito:** decidir qué delegar, a qué agente y con qué esfuerzo, y cuándo sugerir compactar o reiniciar.

- **Cuándo se activa:** antes de lanzar subagentes, al arrancar una tarea larga o de muchos archivos, o cuando el usuario dice que la conversación se puso cara o larga.
- **Entradas:** tamaño y autonomía de la tarea, perfiles de agentes y estado de la conversación.
- **Salida:** recomendación breve de delegación o continuidad; ofrece compactar o preparar traspaso cuando corresponde.
- **Ejemplo:** pedir una recomendación antes de lanzar un agente para una búsqueda amplia.
- **Límites:** no conoce el conteo exacto de tokens ni puede cambiar por sí misma el modelo activo; no usa esfuerzo `max`; solo habla cuando el ahorro es real.
