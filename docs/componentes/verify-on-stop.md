# Hook `verify-on-stop`

**Propósito:** ejecutar el check del proyecto al detenerse cuando está configurado y se cumplen los requisitos.

- **Cuándo se activa:** configuración Stop habilitada, check ejecutable, `HEAD` existente y cambios no Markdown pendientes; puede omitirse con `CLAUDE_SKIP_VERIFY=1`.
- **Entradas:** JSON por stdin, `CLAUDE_PROJECT_DIR` o `cwd`, estado Git y contenido de cambios.
- **Salida:** ejecuta `scripts/check.sh`; si falla, impide que Claude se detenga en el primer intento y evita un bucle en el reintento. Guarda una huella tras el éxito.
- **Ejemplo:** activar manualmente la entrada Stop de `settings.example.json` en la configuración del usuario.
- **Límites:** no crea el check del proyecto ni realiza llamadas de red; ignora cambios solo Markdown.
