# Web de Francisco Recaite

Web estática (un único `index.html` y la carpeta `img/`) publicada en Vercel.

- **Despliegue:** Vercel publica automáticamente cada cambio que se sube a la rama `main`.
- **Encuestas de los artículos:** las respuestas se guardan en Supabase (proyecto `web-francisco-recaite`).
  - `encuesta_respuestas`: respuestas anónimas a las tres preguntas de cada artículo.
  - `encuesta_notas`: comentarios libres. Solo se leen desde el panel de Supabase.
  - La web solo puede insertar filas y leer los porcentajes agregados (función `encuesta_resultados`).
- La clave de Supabase que aparece en `index.html` es la clave pública (publishable); está pensada para ir en el navegador.
