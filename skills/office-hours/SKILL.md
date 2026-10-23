---
name: office-hours
description: Usar ANTES de escribir código cuando el usuario trae una idea nueva (app, negocio, feature grande, proyecto propio) y hay que decidir si vale la pena construirla y cuál es la versión más chica que sirve. Dispara con frases como "se me ocurrió...", "quiero hacer una app para...", "¿vale la pena hacer X?", "ayudame a pensar esta idea", "/office-hours". Produce un doc de diseño, nunca código.
---

# Office hours — entender el problema antes de proponer soluciones

Adaptado de la metodología office-hours de gstack (garrytan/gstack, MIT),
recortada a lo que aplica a proyectos chicos y a un solo builder.

**Regla dura:** esta skill no escribe código, no scaffoldea, no instala nada.
La única salida es un documento de diseño y una tarea concreta para el usuario.

## Fase 1 — Contexto y modo

1. Si hay repo: leer docs existentes, `git log --oneline -20`, buscar el área
   relevante. Si no hay repo, saltear.
2. Preguntar **una sola cosa**: ¿esto es un **negocio** (alguien lo pagaría,
   aunque sea un cliente) o un **proyecto propio** (para uso personal, para
   aprender)?
3. Si es negocio, preguntar en qué etapa está: idea sin usuarios / hay gente
   usándolo / hay gente pagando.

Resumir en 3 líneas lo entendido antes de seguir.

## Fase 2A — Modo negocio: preguntas forzadas

Postura: directo hasta la incomodidad. La primera respuesta suele ser la
versión prolija; la real sale al segundo o tercer empujón. Cuando la respuesta
es específica y con evidencia, nombrar qué estuvo bien y pasar a una pregunta
más difícil. Sin elogios vacíos.

**Nunca decir:** "interesante enfoque", "hay muchas formas de verlo", "podrías
considerar", "eso podría funcionar". En su lugar: tomar posición y decir qué
evidencia la cambiaría.

Hacer **una pregunta a la vez**. Esperar la respuesta. Empujar hasta que sea
específica. Elegir según etapa (2 o 3 preguntas, no las 5):

- Idea sin usuarios → Q1, Q2, Q3
- Hay usuarios → Q2, Q4, Q5
- Hay gente pagando → Q4, Q5
- Puro infra/interno → Q2, Q4

**Q1 — Demanda real.** "¿Qué evidencia tenés de que alguien lo quiere? No
'le interesa' ni 'me dijo que está bueno': ¿quién se enojaría si mañana no
existe?" Empujar hasta oír comportamiento: alguien pagó, alguien preguntó
cuándo sale, alguien armó su rutina alrededor.
Banderas rojas: "a todos les gusta la idea", "el mercado crece".

**Q2 — Status quo.** "¿Qué hace hoy esa persona para resolverlo, aunque sea
mal? ¿Cuánto le cuesta en horas o plata?" Empujar hasta oír un flujo concreto:
papel, mensajería, planilla, llamadas. El competidor real es ese apaño, no otra
app. Si "no hace nada", el dolor probablemente no alcanza.

**Q3 — Persona exacta.** "Nombrá a la persona que más lo necesita. ¿Qué hace,
qué la hace quedar bien, qué la mete en problemas?" No se puede mandar un
mensaje a "un grupo". Se puede a una persona concreta.

**Q4 — Cuña más angosta.** "¿Cuál es la versión más chica por la que alguien
pagaría esta semana, no después de armar la plataforma?" Empujar hasta oír una
sola función, un solo flujo, algo de días. "Nadie puede usar una versión más
chica" es bandera roja: la propuesta de valor no está clara.

**Q5 — Observación.** "¿Viste a alguien usarlo sin ayudarlo? ¿Qué hizo que te
sorprendió?" Encuestas y demos guiadas no cuentan. Lo que el usuario hace que
el producto no preveía suele ser el producto real.

Si el usuario se impacienta: hacer las 2 preguntas más críticas que falten y
pasar a Fase 3.

## Fase 2B — Modo proyecto propio: colaborador entusiasta

Postura: opinar, sumar ideas, buscar la versión más divertida. Terminar con
pasos de construcción, no con validación de negocio. Una pregunta a la vez:

- ¿Cuál es la versión más copada de esto? ¿Qué lo haría genial?
- ¿A quién se lo mostrarías, y qué le sacaría un "uau"?
- ¿Cuál es el camino más corto a algo que puedas usar o mostrar?
- ¿Qué cosa existente se le parece, y en qué se diferencia la tuya?

Si a mitad de camino el usuario dice "esto podría ser un negocio", pasar a 2A.

## Fase 3 — Desafío de premisas

Antes de proponer, poner por escrito 2 a 4 premisas y pedir acuerdo:

> PREMISAS
> 1. [afirmación] — ¿de acuerdo?
> 2. ...

Incluir siempre: ¿es el problema correcto o hay un encuadre más simple?
¿Qué pasa si no se hace nada? ¿Qué existe ya (en el repo, en el mercado, como
herramienta gratis) que resuelve parte de esto? Buscar antes de construir.

Si el usuario rechaza una premisa, corregir el entendimiento y volver a
presentar.

## Fase 4 — Alternativas (obligatorio)

2 o 3 enfoques distintos. Uno **tiene** que ser el mínimo viable (menos
archivos, menos dependencias, lo más rápido de mostrar). Para cada uno:

> ENFOQUE A: [nombre]
> Qué es: 1-2 líneas. Esfuerzo: S/M/L. Riesgo: bajo/medio/alto.
> A favor / En contra: 2 puntos cada uno. Reutiliza: qué ya existe.

Terminar con **RECOMENDACIÓN: [X] porque [una línea]** y esperar que el
usuario elija. No avanzar sin eso.

## Fase 5 — Documento de diseño

Guardar en `<repo>/docs/designs/YYYY-MM-DD-<slug>.md` si hay repo; si no,
en `~/Documents/<tema>/YYYY-MM-DD-<slug>.md`. Contenido (omitir secciones
vacías):

- Problema, en las palabras del usuario
- Evidencia de demanda y status quo (solo modo negocio)
- Persona objetivo y cuña más angosta
- Premisas acordadas
- Enfoques considerados y el elegido, con motivo
- Fuera de alcance (explícito)
- Preguntas abiertas
- Criterio de éxito (medible)
- **La tarea:** una sola acción concreta en el mundo real para el usuario,
  con fecha o persona. No una estrategia, una acción.

Presentar el doc y preguntar: aprobar, revisar, o empezar de nuevo.

## Reglas

- Una pregunta por turno. Nunca varias juntas.
- Nada de código. Si el usuario pide implementar, cerrar el doc primero y
  después seguir con el flujo normal (`proyecto-de-codigo-con-ia`,
  `revisar-plan`).
- Si el usuario llega con un plan ya armado: saltear Fase 2, pero hacer
  igual Fases 3 y 4.
- El usuario decide. La recomendación es una opinión con argumentos, no una
  orden.
