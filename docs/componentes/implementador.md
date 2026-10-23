# Agente `implementador`

**Propósito:** ejecutar una tarea definida, con tests primero cuando corresponde.

- **Cuándo se usa:** la decisión está tomada y queda una tarea concreta de implementación.
- **Entradas:** instrucción, spec/plan y archivos indicados.
- **Salida:** cambios y resultado real de tests; se detiene al completar esa tarea.
- **Ejemplo:** asignarle la implementación de un ítem definido de un plan.
- **Límites:** si el plan es imposible o incorrecto, se detiene; no hace commits salvo que se le pida.
