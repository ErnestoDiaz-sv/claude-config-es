---
name: investigar
description: Usar cuando algo se rompió y hay que encontrar la causa antes de tocar código — el usuario reporta un error, stack trace, comportamiento raro, "dejó de funcionar", "antes andaba", o pide "arreglá este bug". Dispara también con "/investigar". Impone causa raíz antes que fix, límite de 3 hipótesis, y test de regresión.
---

# Investigar — causa raíz antes que fix

Adaptado de la skill investigate de gstack (garrytan/gstack, MIT), recortada
y combinada con reglas generales de verificación.

**Ley de hierro:** NO HAY FIX SIN INVESTIGAR LA CAUSA RAÍZ PRIMERO. Arreglar
síntomas genera bugs en cadena y quema cuota a ciegas.

## Fase 1 — Juntar evidencia

1. **Síntomas:** leer el error, el stack trace, los pasos para reproducir.
   Si falta contexto, hacer **una** pregunta por turno, no cinco.
2. **Código:** seguir el camino desde el síntoma hacia atrás. Buscar todas
   las referencias, leer la lógica alrededor del punto de falla.
3. **Cambios recientes:** `git log --oneline -20 -- <archivos afectados>`.
   Si antes andaba, la causa está en el diff.
4. **Reproducir:** ¿se dispara de forma determinística? Si no, juntar más
   evidencia antes de seguir.
5. **Si está desplegado:** leer los logs de producción del momento del error,
   no solo el código. Que el build pase no dice nada del runtime.
6. **Si es de UI:** verlo en el navegador contra la URL real, no suponer desde
   el código.

Salida obligatoria: **"Hipótesis de causa raíz: ..."** — una afirmación
específica y verificable de qué está mal y por qué.

## Fase 2 — Patrones conocidos

Chequear si encaja en uno:

- **Race condition:** intermitente, depende del timing. Estado compartido.
- **Null/undefined propagado:** TypeError, "cannot read property". Faltan
  guardas en valores opcionales.
- **Estado corrupto:** datos inconsistentes, updates a medias. Transacciones,
  callbacks, hooks.
- **Integración externa:** timeout, respuesta inesperada. APIs de terceros.
- **Deriva de configuración:** anda local, falla en deploy. Variables de
  entorno, secrets, versión de runtime.
- **Cache viejo:** muestra datos viejos, se arregla limpiando cache.

Mirar también si hubo fixes previos en los mismos archivos: bugs
recurrentes en el mismo lugar son olor a arquitectura, no coincidencia.

Si no encaja en ningún patrón, buscar el tipo de error en la web.
**Sanitizar primero:** sin hostnames, IPs, rutas, SQL ni datos de clientes.
Buscar la categoría del error, no el mensaje crudo.

## Fase 3 — Verificar la hipótesis antes de tocar nada

1. Confirmar con un log temporal, assertion o debug output en el punto
   sospechado. Reproducir. ¿La evidencia coincide?
2. Si la hipótesis falla: volver a Fase 1 con más evidencia. No adivinar.
3. **Regla de 3 golpes:** si fallan 3 hipótesis, **PARAR** y decir:

   > "Probé 3 hipótesis y ninguna coincide. Puede ser un problema de
   > arquitectura, no un bug simple."

   Ofrecer: seguir con una hipótesis nueva (describirla), agregar logging y
   esperar a que vuelva a pasar, o revisarlo juntos con más contexto.

Banderas rojas para frenar:
- "Fix rápido por ahora" — no existe "por ahora".
- Proponer un fix antes de trazar el flujo de datos — es adivinar.
- Cada fix revela un problema nuevo en otro lado — capa equivocada.

## Fase 4 — Implementar

1. Arreglar la causa raíz, no el síntoma. Una guarda en la función
   compartida vale más que una guarda en cada caller.
2. Diff mínimo: menos archivos, menos líneas. No refactorizar lo de al lado.
3. **Test de regresión** que falla sin el fix y pasa con el fix. Si el
   proyecto no tiene tests, decirlo y proponer el mínimo, no inventar
   infraestructura de testing.
4. Correr la suite completa. Cero regresiones.
5. Si el fix toca más de 5 archivos: avisar al usuario antes de seguir. Es
   mucho para un bug.

## Fase 5 — Verificar y reportar

Reproducir el escenario original y confirmar que está arreglado. No es
opcional. Si está desplegado, revisar los logs después del deploy.

Reporte corto:

- **Síntoma:** qué vio el usuario
- **Causa raíz:** qué estaba mal en realidad
- **Fix:** qué cambió, con archivos
- **Evidencia:** salida de tests, reproducción mostrando que anda
- **Test de regresión:** dónde está
- **Relacionado:** bugs previos en la misma zona, notas de arquitectura
- **Estado:** LISTO / LISTO CON RESERVAS (no se pudo verificar del todo) /
  BLOQUEADO (causa no clara, escalado)

## Reglas

- Nunca aplicar un fix que no se puede verificar.
- Nunca decir "esto debería arreglarlo". Probarlo.
- 3 hipótesis fallidas = parar y cuestionar la arquitectura, no insistir.
- Más de 5 archivos = avisar antes.
