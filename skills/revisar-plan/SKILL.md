---
name: revisar-plan
description: Usar cuando ya hay un plan o spec de implementación escrito y hay que buscarle agujeros ANTES de programar — "revisá el plan", "¿qué le falta a esto?", "¿estoy metiendo de más?", "poné a prueba este enfoque", o al terminar el plan de una feature no trivial. Dispara también con "/revisar-plan". Elige modo de alcance (mantener, reducir, expandir) y no toca código.
---

# Revisar plan — agujeros y alcance antes de programar

Adaptado de la skill ceo-review de gstack (garrytan/gstack, MIT), recortada
a proyectos chicos: sin secciones de observabilidad, dashboards ni escala
100x. El default es mantener o reducir alcance, nunca agregar en silencio.

**Regla dura:** no se escribe código. La salida es el plan corregido.

## Paso 0 — Premisas y alternativas

**0A. Desafío de premisas.** Responder por escrito antes de revisar detalles:
1. ¿Es el problema correcto? ¿Un encuadre distinto lo hace mucho más simple?
2. ¿Cuál es el resultado real para el usuario? ¿El plan es el camino más
   directo o resuelve un problema proxy?
3. ¿Qué pasa si no se hace nada?

**0B. Qué ya existe.** Mapear cada sub-problema del plan a código que ya
está en el repo, a la librería estándar, a una feature nativa de la
plataforma, o a una dependencia ya instalada. ¿El plan reconstruye algo
que ya existe?

**0C. Alternativas (obligatorio).** 2 o 3 enfoques, uno **tiene** que ser el
mínimo viable. Para cada uno: nombre, qué es, esfuerzo S/M/L, riesgo,
2 a favor, 2 en contra, qué reutiliza. Terminar con
**RECOMENDACIÓN: [X] porque [una línea]** y esperar la elección.

## Paso 1 — Modo de alcance

Presentar las 4 opciones y proponer un default según el caso:

1. **MANTENER** — el alcance está aceptado; hacerlo a prueba de balas.
   Default para bugs, refactors y features chicas.
2. **REDUCIR** — cirujano: la versión mínima que logra el resultado central,
   cortar el resto. Sugerir si el plan toca más de 15 archivos o suma
   dependencias nuevas.
3. **EXPANDIR SELECTIVO** — mantener la base y presentar cada expansión
   posible **una por una** para que el usuario acepte o rechace.
   Default para mejoras a features existentes.
4. **EXPANDIR** — pensar en grande. Solo si el usuario lo pide.

En todos los modos: cada cambio de alcance es un opt-in explícito. Nunca
agregar ni sacar alcance en silencio. Una vez elegido, sostenerlo.

## Paso 2 — Interrogación temporal

Pensar la implementación por adelantado y resolver AHORA lo que si no se
decide a mitad de camino:

> HORA 1 (bases): ¿qué necesita saber quien implementa para arrancar?
> HORA 2-3 (lógica central): ¿qué ambigüedades va a encontrar?
> HORA 4-5 (integración): ¿qué lo va a sorprender?
> HORA 6+ (pulido y tests): ¿qué va a lamentar no haber planificado?

Cada punto que salga se convierte en una decisión escrita en el plan.

## Paso 3 — Checklist

Evaluar cada ítem. Si no hay hallazgos, decir "sin hallazgos" y seguir; no
saltear sin mirar. Presentar los hallazgos **de a uno** y esperar respuesta.

- **Errores con nombre.** Para cada camino que puede fallar: qué excepción,
  qué la dispara, quién la atrapa, qué ve el usuario. "Manejar errores" a
  secas no vale. Un catch-all siempre es sospechoso.
- **Flujos de datos con sus sombras.** Cada flujo tiene el camino feliz y
  tres sombras: entrada nula, entrada vacía, error aguas arriba. Trazar los
  cuatro.
- **Casos borde de interacción** (si hay UI): doble click, salir a mitad de
  una acción, conexión lenta, estado viejo, botón atrás, texto de 60
  caracteres, cero resultados.
- **Seguridad mínima:** entradas validadas, quién puede hacer qué, secrets
  fuera del código.
- **Tests:** para cada flujo nuevo y cada camino de error, ¿qué test lo
  cubre? ¿Existe? Si el proyecto no tiene tests, decirlo y proponer el
  mínimo, no montar infraestructura nueva.
- **Datos y estado:** tablas o campos nuevos, migraciones, consultas N+1,
  restricciones de integridad (mejor en la base que en la app).
- **Todo lo diferido, por escrito.** Intenciones vagas son mentiras. Lo que
  no entra va a una sección "Fuera de alcance" o "Después" con motivo.

## Salida

Actualizar el plan (o el doc de diseño en `docs/designs/`) y cerrar con:

**RESUMEN DE REVISIÓN**
- Modo: [elegido]
- Mayores hallazgos: [los 3 principales]
- Camino recomendado: [qué hacer ahora]
- Alcance aceptado: [qué entra]
- Diferido: [qué queda afuera y por qué]
- Estado: LISTO / LISTO CON RESERVAS / BLOQUEADO (falta contexto)

## Reglas

- Sin cambios de código.
- Un hallazgo por turno, nunca varios juntos.
- Cada ítem de la checklist se evalúa; "no aplica" sin mirar no vale.
- El usuario tiene el control del alcance, siempre.
