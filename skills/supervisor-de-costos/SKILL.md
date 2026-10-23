---
name: supervisor-de-costos
description: Supervisor de costo/eficiencia de la propia interacción: decide qué delegar a subagentes y con qué modelo según el peso de la tarea, aplica un piso mínimo por debajo del cual delegar sale más caro que hacerlo inline, y avisa cuando la conversación se puso pesada y conviene compactar o reiniciar con un traspaso. Activarla proactivamente al arrancar una tarea nueva y antes de lanzar cualquier subagente.
---

# Supervisor de costos e interacción

Vos (el modelo actual, sea el que sea) actuás además como supervisor de la
eficiencia de esta misma conversación. El objetivo es usar contexto y
delegación solo cuando aporten valor.

## Límites reales — decilo si hace falta, no finjas que no existen

- **No podés cambiarte el modelo a vos mismo.** Cambiar el modelo para toda
  la sesión es una decisión del usuario mediante el comando correspondiente.
- **No tenés el conteo exacto de tokens gastados** en esta conversación. Si
  existe un comando de costo, recomendalo cuando sea relevante; no inventes
  una cifra.
- Lo que sí podés hacer sin pedirle nada al usuario: delegar un subtask
  mecánico a un subagente con un modelo más económico, si la plataforma lo
  permite.

## Cuándo activarse (proactivo, pero no molesto)

Revisá esto en dos momentos, no en cada mensaje:
1. **Al empezar una tarea nueva y claramente delimitada** dentro de la
   conversación (el usuario pide algo distinto a lo anterior).
2. **De tanto en tanto**, cuando notés que la conversación ya lleva varios
   turnos con archivos grandes leídos, mucho ida y vuelta, o el usuario
   menciona que "esto se está poniendo largo/caro".

No interrumpas por un ahorro marginal. Solo decí algo cuando el ahorro es
real: una tarea mecánica que no necesita razonamiento del modelo principal,
o una conversación que ya es objetivamente pesada.

## 1. Reparto de modelos — el modelo principal orquesta

Usá el modelo principal para arquitectura, trade-offs ambiguos, debugging con
varias hipótesis, seguridad y la decisión de qué delegar. No recomiendes
cambiar de modelo sin una razón clara.

Los perfiles incluidos en `agents/` cumplen estos roles:
- **`explorador`** — tareas mecánicas de búsqueda, lectura y resumen.
- **`implementador`** — UNA tarea ya especificada, tests primero, y para.
- **`revisor`** — verificador de solo lectura: diff contra spec/tarea, corre
  tests, empieza con `VEREDICTO: APROBADO` o `VEREDICTO: CAMBIOS NECESARIOS`.
  Bucle revisor↔implementador: máximo 2 vueltas, después parar y explicar.

Los subagentes NO ven la conversación: el briefing lleva la petición con las
palabras del usuario, rutas de archivos y el resultado del paso anterior.
Para algo que no encaja en los perfiles, usá un agente con modelo explícito si
la plataforma ofrece esa opción.

## 2. Cuándo delegar — hay un piso, no delegues por reflejo

Cada subagente arranca con un costo fijo (instrucciones, herramientas y
briefing): delegar una tarea chica puede salir más caro que hacerla inline.

Delegá cuando se cumplen las tres:
1. El trabajo es **pesado de leer** (muchos archivos, mucho output de tools).
2. El resultado **comprime mucho** (lee muchos archivos → devuelve pocas
   líneas).
3. Es **autocontenido**: se briefea en un párrafo, sin arrastrar decisiones
   de la conversación.

Hacelo inline si la tarea toca pocos archivos conocidos o depende del contexto
acumulado. Recrear ese contexto cuesta más de lo que ahorra — y si el
subagente vuelve mal, pagás el rehacer además del intento fallido.

Un agente que hereda todo el contexto no es automáticamente más barato: sirve
para paralelizar, no para ahorrar.

Techo de concurrencia: 3-4 agentes cuando cada uno lee todo el repo (el
detalle está en `proyecto-de-codigo-con-ia`).
Avisá cuando delegaste y por qué, en una línea.

## 2b. Trabajo pesado que SÍ depende del contexto

Tres salidas, en orden:

1. **Separá la decisión de la ejecución.** Decidí inline y delegá la ejecución
   ya resuelta, con instrucciones explícitas.
2. **Escribí el contexto en un archivo** en vez de arrastrarlo en el briefing.
   Un subagente fresco puede leer el documento y pagar esa lectura en su propio
   contexto. Si la tarea se va a delegar más de una vez, el doc puede ahorrar
   duplicación.
3. **Briefing como puntero, no como transcripción.** Indicar un archivo y una
   sección cuesta menos que pegar el contenido una y otra vez.

Si después de eso la tarea sigue pesada e inseparable del hilo, hacela inline
y aceptá el costo, o pará y ofrecé compactar la conversación. Paralelizá solo
cuando el valor buscado es tiempo de reloj y el costo se acepta a sabiendas.

## 3. Conversación pesada → compactar o reiniciar

El contexto acumulado y releído puede dominar el costo de una sesión larga.
La palanca principal suele ser evitar que una sesión crezca sin necesidad:
- **Una tarea = una sesión.** Al cerrar una tarea y arrancar otra que no
  depende de los detalles, sugerí una sesión nueva en una línea.
- **Compactar antes de alejarse**, no al volver, para resumir antes de una
  pausa larga.
- **Navegador:** preferí lectura de texto y consultas que devuelvan solo los
  datos; capturas solo para verificación visual necesaria.
- Si hay un comando de uso/costo, recomendalo si preguntan en qué se gasta.

Señales de que conviene cortar (heurísticas, usalas en conjunto):
- Se leyeron varios archivos grandes o se generó mucho output de herramientas.
- Hay muchos turnos sobre temas resueltos que ya no hacen falta en contexto.
- El usuario dice explícitamente que se siente lento o pesado.
- Se está por arrancar una tarea nueva y grande que no depende de los detalles
  finos de lo ya hablado.

Cuando pase, ofrecé **las dos rutas**, no elijas por el usuario:
1. **Compactar** — seguir en la misma sesión con contexto resumido.
2. **Reiniciar con un paquete de traspaso** — preparar un bloque copiable con
   qué se estaba haciendo, decisiones tomadas, archivos relevantes y próximo
   paso concreto. Si el proyecto ya tiene un archivo de handoff, ofrecer
   actualizarlo en vez de dar un bloque suelto.

## Tono

Una línea, directo, sin alarmismo ni disculpas. El valor de esta skill es
ahorrar esfuerzo sin darle una charla sobre eficiencia cada vez.
