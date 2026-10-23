# Script `statusline.sh`

**Propósito:** mostrar el modelo y el uso de contexto que recibe en la entrada.

- **Cuándo se activa:** Claude Code lo ejecuta como comando status line si se configura.
- **Entradas:** JSON por stdin con `model.display_name` y opcionalmente `context_window.total_input_tokens`.
- **Salida:** nombre del modelo y, si hay valor de contexto, una línea con miles de tokens y umbral indicado por el script.
- **Ejemplo:** configurar `~/.claude/statusline.sh` según `settings.example.json`.
- **Límites:** sin el campo de tokens muestra solo el modelo; depende de `jq`.
