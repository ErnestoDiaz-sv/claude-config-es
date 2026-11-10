# Script `statusline.sh`

**Propósito:** mostrar el modelo y el uso de contexto que recibe en la entrada.

- **Cuándo se activa:** Claude Code lo ejecuta como comando status line si se configura.
- **Entradas:** JSON por stdin con `model.display_name` y opcionalmente `context_window.total_input_tokens`, `context_window.context_window_size` y `context_window.used_percentage`.
- **Salida:** nombre del modelo y, si hay valor de contexto, una línea con miles de tokens usados sobre el tamaño de la ventana, en verde, amarillo (desde 50 %) o rojo (desde 75 %).
- **Ejemplo:** configurar `~/.claude/statusline.sh` según `settings.example.json`.
- **Límites:** sin el campo de tokens muestra solo el modelo; si falta el tamaño de la ventana asume 200k; depende de `jq`.
