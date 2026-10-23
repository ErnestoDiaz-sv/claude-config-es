# Contribuir

Las propuestas pequeñas y enfocadas son más fáciles de revisar. Antes de abrir un cambio, explicá el problema que resuelve y evitá ampliar el alcance sin necesidad.

## Skills y correcciones

- Proponé una skill nueva cuando aporte un procedimiento reusable y concreto; describí cuándo se activa, qué recibe, qué produce y sus límites.
- Para corregir una skill o agente existente, mantené el cambio fiel a su intención y respaldá las afirmaciones con el contenido del archivo.
- No cambies silenciosamente los archivos existentes de `skills/`, `agents/`, `hooks/` ni `statusline.sh`.
- Mantené la documentación del proyecto en español y el código, nombres de archivos y comentarios de scripts en inglés.

## Verificación

Antes de proponer un cambio, ejecutá desde la raíz:

```bash
./scripts/check.sh
```

Incluí en la propuesta qué verificaste y el resultado real. No agregues dependencias sin justificar que lo existente no alcanza. No incluyas secretos, credenciales ni archivos `.env`.
