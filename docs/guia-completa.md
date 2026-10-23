# Guía completa

## Filosofía y flujo

El modelo principal decide el enfoque, resuelve ambigüedades y coordina. Los subagentes ejecutan tareas acotadas y con un resultado claro. Este reparto no requiere delegar cada paso: el trabajo chico suele ser más directo en línea.

Las skills describen procedimientos que se invocan cuando aplican. Los agentes de `agents/` tienen perfiles distintos: exploración de solo lectura, implementación de una tarea definida y revisión independiente. El usuario conserva las decisiones de alcance y las acciones externas.

## Cuándo delegar: el piso

Delegá cuando el trabajo implique leer mucho, el resultado pueda resumirse de forma compacta y la tarea sea autocontenida. Hacelo en línea cuando afecta pocos archivos conocidos o depende de decisiones y contexto acumulados. La concurrencia también añade coordinación; no la uses por reflejo.

## Una tarea = una sesión

Al cerrar una tarea y comenzar otra independiente, una sesión nueva evita arrastrar contexto que ya no hace falta. Si se continúa en la misma conversación, resumí lo necesario antes de una pausa larga.

## Verificación Stop, optativa

El hook incluido se instala como archivo, pero no queda activado hasta que el usuario combina su configuración de `settings.example.json`. Para que actúe, el repositorio debe ofrecer `scripts/check.sh` ejecutable y tener cambios no confirmados distintos de Markdown. El script corre los checks del proyecto, no los inventa.

## Barra de calidad

Usá [`quality-bar.md`](../quality-bar.md) como criterios verificables de ingeniería. Distingue automatizaciones simples de revisiones manuales; no es una afirmación de que todos los proyectos del usuario ya los cumplan.

## Escalera de reutilización

Antes de escribir algo nuevo, buscá en este orden: (1) helper o patrón existente, (2) biblioteca estándar, (3) función nativa de la plataforma y (4) dependencia ya instalada. No agregues una dependencia para resolver unas pocas líneas.

## Ejemplos reutilizables

- [`examples/python/scripts/check.sh`](../examples/python/scripts/check.sh): Ruff y pytest.
- [`examples/node/scripts/check.sh`](../examples/node/scripts/check.sh): scripts npm de lint y test.
- [`examples/AGENTS.md`](../examples/AGENTS.md): reglas genéricas de proyecto.
