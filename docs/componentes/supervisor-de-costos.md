# Skill `supervisor-de-costos`

**Propósito:** decidir cuándo delegar, mantener el trabajo en línea o sugerir compactar/reiniciar.

- **Cuándo se activa:** al iniciar una tarea delimitada y cuando la conversación acumula contexto pesado.
- **Entradas:** tamaño y autonomía de la tarea, perfiles de agentes y estado de la conversación.
- **Salida:** recomendación breve de delegación o continuidad; ofrece compactar o preparar traspaso cuando corresponde.
- **Ejemplo:** pedir una recomendación antes de lanzar un agente para una búsqueda amplia.
- **Límites:** no conoce el conteo exacto de tokens ni puede cambiar por sí misma el modelo activo; no delega por un ahorro marginal.
