---
name: supervisor-de-costos
description: Reparto de costo entre el modelo principal y los subagentes explorador/implementador/revisor — qué delegar, a qué modelo y con qué esfuerzo, el piso por debajo del cual delegar sale más caro que hacerlo inline, y cuándo cortar una conversación pesada con /compact o un traspaso. Usar antes de lanzar subagentes, al arrancar una tarea larga o de muchos archivos, o cuando el usuario dice "esto se puso caro/largo".
---

# Supervisor de costos

Objetivo: que la conversación no cueste más de lo necesario, sin que el
usuario tenga que pedirlo. Hablá solo cuando el ahorro es real, en una
línea, sin sermón.

## Límites

- No podés cambiar el modelo de la sesión: eso es `/model` del usuario.
  No propongas cambiarlo sin una razón clara.
- No sabés cuántos tokens se gastaron: el usuario lo ve con `/usage`. No
  inventes una cifra.
- Sí podés delegar a un subagente más barato (Agent tool).

## Quién hace qué

| Agente | Modelo | Esfuerzo | Para |
|---|---|---|---|
| `explorador` | `haiku` | low | buscar, listar, leer y resumir, "qué cambió desde X" |
| `implementador` | `sonnet` | medium | UNA tarea ya especificada, tests primero |
| `revisor` | `sonnet` | high | diff vs spec, corre tests, veredicto; bucle con implementador máx. 2 vueltas |
| Modelo principal (inline) | — | — | arquitectura, trade-offs, debugging con varias hipótesis, seguridad, y decidir qué delegar |

El modelo y el esfuerzo de cada agente ya están en su frontmatter. Pasá
`effort` en el Agent tool solo para salir de esa tabla:
- **Escalar por fallo, no por anticipación**: si el revisor pide cambios,
  la segunda vuelta del implementador va en `high`; algo que ya falló en
  `high` va en `xhigh`.
- **`max` nunca.**
- El que edita no sube "por las dudas": con esfuerzo alto tiende a hacer
  cambios que nadie pidió. El que solo lee/juzga sí puede pensar más.

Los subagentes no ven la conversación: el briefing lleva el pedido con las
palabras del usuario, las rutas de archivos y el resultado del paso anterior.

## Cuándo delegar — hay un piso

Cada subagente arranca pagando su system prompt + tools + briefing. Delegá
solo si se cumplen las tres:
1. Es **pesado de leer** (muchos archivos o mucho output).
2. El resultado **comprime mucho** (muchos archivos → pocas líneas).
3. Es **autocontenido** (se briefea en un párrafo).

Si toca 1-3 archivos conocidos o depende del contexto acumulado, inline.
`fork` hereda tu contexto pero corre en tu mismo modelo: sirve para
paralelizar, no para ahorrar.

Pesado *y* dependiente del contexto: decidí vos inline y delegá la
ejecución ya resuelta; si el contexto es largo, escribilo en un archivo
del proyecto y pasá el puntero, no la transcripción.

Avisá en una línea cuando delegaste y por qué.

## Conversación pesada

En una sesión larga, el contexto acumulado se relee en cada turno. La
palanca es que la sesión no crezca:
- **Una tarea = una sesión**: al cambiar de tema, sugerí `/clear`.
- **Compactar antes de alejarse**, no al volver.
- **Navegador como texto**: leer el texto de la página o consultar solo el
  dato; captura de pantalla solo para verificar algo visual.

Cuando la sesión ya pesa (muchos archivos grandes, muchos turnos de temas
cerrados, el usuario la nota lenta, o arranca una tarea grande nueva),
ofrecé las dos rutas y que elija el usuario:
1. `/compact`.
2. Sesión nueva con este bloque (o escrito en el archivo de traspaso del
   proyecto, si tiene uno):
   ```
   ## Contexto para retomar
   Tarea: <una línea>
   Decisiones ya tomadas: <bullets>
   Archivos relevantes: <rutas>
   Próximo paso: <una línea concreta>
   ```
