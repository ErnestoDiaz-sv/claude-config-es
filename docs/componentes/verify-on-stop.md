# Hook `verify-on-stop`

**Propósito:** ejecutar el check del proyecto al detenerse cuando está configurado y se cumplen las condiciones de participación.

- **Cuándo se activa:** configuración Stop habilitada, check ejecutable, `HEAD` existente y cambios no Markdown pendientes; puede omitirse con `CLAUDE_SKIP_VERIFY=1`.
- **Entradas:** JSON por stdin, `CLAUDE_PROJECT_DIR` o `cwd`, estado Git y contenido de cambios.
- **Salida:** ejecuta `scripts/check.sh`; bloquea una detención con error la primera vez y evita bucle en reintento. Guarda una huella tras éxito.
- **Ejemplo:** activar manualmente la entrada Stop de `settings.example.json` en la configuración del usuario.
- **Límites:** no crea el check del proyecto ni realiza llamadas de red; ignora cambios solo Markdown.
