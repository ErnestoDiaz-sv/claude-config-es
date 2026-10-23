# Configuración ligera para Claude Code

Este repositorio reúne instrucciones, agentes, skills y utilidades para trabajar con Claude Code. El enfoque pone al modelo principal a decidir y coordinar, y reserva los subagentes para trabajo acotado; el hook de verificación es optativo. Está diseñado para gastar menos cuota al reducir delegaciones pequeñas y contexto innecesario, pero no hay mediciones de ahorro.

## Inicio rápido

Revisá qué se copiaría y luego instalá:

```bash
./install.sh --dry-run
./install.sh
```

El destino predeterminado es `~/.claude`; `CLAUDE_HOME=/ruta` permite probar o elegir otro. El instalador omite archivos existentes y nunca cambia `settings.json`. Consultá [la guía rápida](docs/guia-rapida.md) antes de combinar manualmente [el ejemplo de configuración](settings.example.json).

## Componentes

| Componente | Descripción | Documentación |
|---|---|---|
| Skills | Siete flujos para investigar, planear, coordinar, limpiar y entregar. | [Índice de componentes](docs/componentes/README.md) |
| Agentes | Exploración, implementación y revisión con responsabilidades acotadas. | [Índice de componentes](docs/componentes/README.md) |
| Hook Stop | Ejecuta de forma optativa los checks del proyecto al detenerse. | [Verificación al detenerse](docs/componentes/verify-on-stop.md) |
| Status line | Muestra el modelo y, si el dato está disponible, el contexto informado. | [Status line](docs/componentes/statusline.md) |
| Plantillas | Ejemplos de instrucciones globales, settings y reglas de proyecto. | [Guía completa](docs/guia-completa.md) |
| Calidad | Criterios mecánicos y manuales para proyectos de código. | [Barra de calidad](quality-bar.md) |

## Cómo funciona

El modelo principal define el enfoque y decide si delegar; los agentes ejecutan tareas delimitadas. Las skills aportan procedimientos bajo demanda. El usuario elige si instala el hook y activa su configuración en `settings.json`; para participar, cada proyecto debe tener un `scripts/check.sh` ejecutable.

## Documentación

- [Guía rápida](docs/guia-rapida.md): instalación, primer uso y verificación.
- [Guía completa](docs/guia-completa.md): filosofía, delegación y calidad.
- [Seguridad](docs/seguridad.md): alcance, lecturas, escrituras y auditoría.
- [Preguntas frecuentes](docs/faq.md): instalación, personalización y problemas comunes.
- [Índice de componentes](docs/componentes/README.md): páginas detalladas de cada skill, agente y script.
- [Contribuir](CONTRIBUTING.md) · [Seguridad y reporte](SECURITY.md) · [Cambios](CHANGELOG.md).

## Créditos

Algunas skills se adaptaron de proyectos externos; sus avisos y licencias están en [NOTICE.md](NOTICE.md). El resto del material se ofrece según [LICENSE](LICENSE).
