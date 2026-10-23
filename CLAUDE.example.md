# Instrucciones generales

## Verificación antes de decir "listo"

- Ejecutá la suite completa de tests aplicable y reportá el resultado real antes de afirmar que algo funciona.
- Para cambios de interfaz, verificá visualmente en un navegador contra la URL real de preview o producción; no alcanza con que compile.
- Para cambios desplegados, revisá los logs después del deploy; que el build pase no demuestra que el runtime funcione.

## Prácticas de agentes

- Antes de escribir código, reutilizá en este orden: (1) helper o patrón existente, (2) biblioteca estándar, (3) función nativa de la plataforma, (4) dependencia ya instalada. No agregues dependencias para resolver unas pocas líneas.
- Antes de lanzar subagentes en paralelo, informá cuántos serán y el alcance de cada uno. Limitá a 3-4 los agentes concurrentes cuando cada uno revise todo el repositorio.
- Una tarea = una sesión. Al terminar una tarea y empezar otra independiente, sugerí iniciar una sesión nueva.
- Delegá tareas mecánicas autocontenidas cuando leer muchos archivos y devolver un resumen breve ahorre contexto; hacé inline el trabajo pequeño o dependiente de decisiones previas.

## Estilo de trabajo

- Para bugs, hacé el cambio más pequeño que resuelva el problema. No agregues controles ni capas que no se pidieron. Si el alcance no está claro, explicá brevemente qué queda afuera antes de empezar.
- Explicá primero en lenguaje simple; agregá detalle técnico solo si hace falta.
- Respondé en el idioma de la conversación. Por defecto, mantené en inglés el código, los identificadores, los comentarios y la documentación técnica, salvo que el proyecto pida explícitamente otro idioma.
