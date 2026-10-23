---
name: proyecto-de-codigo-con-ia
description: Usar cuando (a) el usuario arranca un proyecto de código nuevo con IA y quiere estructurarlo bien desde el principio; o (b) un agente/proyecto existente muestra señales de que se volvió difícil de manejar con IA — respuestas contradictorias, caminos raros/ineficientes, instrucciones que crecieron demasiado; o (c) el usuario pregunta cuándo usar sub-agentes, cómo verificar automáticamente el trabajo de un agente, cómo paralelizar tareas o cómo estructurar código para que un agente lo navegue bien.
---

# Proyecto de código con IA — arrancar bien o diagnosticar un lío

Checklist accionable basado en prácticas compartidas por profesionales de
desarrollo de software asistido por IA. Las prácticas son guías, no sustituyen
la evidencia del repositorio ni la decisión del usuario.

## Caso A — proyecto nuevo, arrancar bien

Flujo de 5 pasos:

1. **Alinear antes de planear ("grill me"):** en vez de escribir un
   spec de una sentada, interrogar al usuario, una pregunta a la vez,
   con recomendación propia en cada una, hasta llegar a un
   entendimiento compartido — no hasta producir un documento. Las
   preguntas concretas, la postura anti-adulación y el formato del doc
   de diseño están en la skill `office-hours` — invocarla para este
   paso.
2. **Resumir en un PRD** (documento de destino): problema, solución,
   historias de usuario, decisiones de implementación/testing, y una
   sección explícita de "fuera de alcance". No hace falta revisarlo
   línea por línea si el paso 1 se hizo bien — ahí ya se logró la
   alineación real.
3. **Cortar el trabajo en slices verticales, no por capa** (schema +
   servicio + UI mínima juntos, no "toda la base de datos primero"):
   arma un backlog en forma de grafo de dependencias (no una lista
   numerada) para poder paralelizar.
4. **Implementar con un loop de verificación real** (TDD, o
   verificación nativa al artefacto vía DOM/estado publicado): sin eso
   el agente programa a ciegas.
5. **Revisar con contexto limpio**, no con el mismo contexto que
   implementó; la revisión hereda la degradación si no se limpia antes.

Entre el paso 2 y el 3, para features no triviales, pasar el PRD por la
skill `revisar-plan`: desafía premisas, exige alternativas con un mínimo
viable, fija el modo de alcance (mantener/reducir por default) y deja
por escrito lo diferido antes de cortar en slices.

Para specs de diseño/interfaz, considerar un formato explorable en vez de
un documento largo cuando mejore la revisión.

## Caso B — proyecto existente que se puso difícil de manejar

Diagnóstico rápido, en orden de probabilidad:

1. **¿El archivo de instrucciones creció mucho?** (CLAUDE.md, system
   prompt de un agente armado). Síntoma típico: contradicciones
   internas, el agente usa el dato/regla equivocada. Solución: mover
   lo condicional a skills, dejar en el archivo siempre-cargado solo
   lo que aplica siempre.
2. **¿Hay sub-agentes que no deberían existir?** Un sub-agente solo se
   justifica para (a) paralelizar mucho trabajo sobre un problema, o
   (b) necesitar una mente sin el contexto previo (ej. revisor de
   código separado del que escribió). Si no encaja en ninguno de los
   dos, sacarlo y reemplazarlo por una tool primitiva.

   **Techo de concurrencia:** máximo 3-4 sub-agentes concurrentes cuando cada
   uno lee todo el repo (reviews, auditorías). Antes de lanzar, decir
   cuántos son y el alcance de cada uno.
3. **¿Hay tools custom que deberían ser primitivas?** Antes de una
   tool custom, ¿alcanza con bash/filesystem/búsqueda web? Verificar si una
   herramienta existente resuelve la necesidad. MCP solo si varios
   agentes/clientes necesitan la misma herramienta gobernada.
4. **¿El código en sí es difícil de navegar para el agente?** Muchos
   archivos chicos con exports cruzados (módulos superficiales) son
   más difíciles de testear/delegar que pocos módulos con interfaz
   chica y mucha funcionalidad adentro (módulos profundos).

## No aplicar como barrido preventivo

Esto se invoca cuando hay una señal concreta (proyecto nuevo, o
síntoma real en uno existente) — no como limpieza retroactiva de
proyectos que andan bien. Documentación/estructura que no se actualiza
junto con el código real termina confundiendo al agente más de lo que
ayuda.
