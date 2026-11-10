# Mantenimiento

## Deriva

`scripts/drift.sh` compara los componentes del repositorio con la copia instalada. Ejecutá `scripts/drift.sh` para ver si hay diferencias o `scripts/drift.sh --diff` para verlas. Las mejoras se hacen en el repositorio y se instalan desde ahí. Si la copia instalada tiene algo mejor, incorporalo al repositorio a mano después de quitar rutas y datos personales.

## Revisión mensual

- Leé el changelog oficial de Claude Code.
- Para cada skill, agente y hook, decidí si conservarlo, actualizarlo o borrarlo.
- Ejecutá `scripts/drift.sh`.
- Ejecutá `scripts/check.sh`.

## Regla de borrado

Cuando una función nativa de Claude Code cubra lo que hace un componente, quitá el componente, su página en `docs/componentes/` y su entrada en `scripts/list-files.sh`.

## Modelos

Los agentes usan alias como `haiku` y `sonnet`, no IDs fijados a una versión. `scripts/check.sh` verifica que no haya IDs fijados.

## Publicar una versión

Actualizá `CHANGELOG.md`, ejecutá `scripts/check.sh` y creá el tag de la versión.

## Registro de revisiones

| Fecha | Qué se revisó | Resultado |
|---|---|---|
