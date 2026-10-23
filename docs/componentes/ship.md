# Skill `ship`

**Propósito:** verificar un proyecto y seguir su flujo real de entrega, sin asumir convenciones.

- **Cuándo se activa:** se pide terminar y entregar cambios.
- **Entradas:** repositorio, suite, build, historial y workflow Git/hosting disponibles.
- **Salida:** verificación, detección del flujo de trabajo y, si corresponde, commit, push, PR y handoff.
- **Ejemplo:** `/ship` cuando el usuario pide entregar cambios.
- **Límites:** se detiene ante tests/build fallidos; pide aclaración si el workflow no se puede inferir y confirma antes de un merge no autorizado.
