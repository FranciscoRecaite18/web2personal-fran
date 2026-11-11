# Publicar la web de Francisco Recaite

Instrucciones para subir esta carpeta a un repositorio **privado** de GitHub y publicarla en **Vercel**.
Se pueden seguir a mano o pasárselas a Claude con GitHub y Vercel conectados.

## Qué hay en la carpeta

| Archivo | Para qué sirve |
|---|---|
| `index.html` | Toda la web: estilos, textos, artículos, esquemas y encuestas |
| `img/` | Imágenes de la web (58) |
| `vercel.json` | Configuración de Vercel (caché de imágenes) |
| `README.md` | Descripción del proyecto para el repositorio |
| `supabase/schema.sql` | Tablas y permisos de las encuestas (ya aplicados; solo como copia) |
| `.gitignore` | Archivos que no se suben |

Es una web estática: **no necesita instalar nada ni compilar**.

## 1. Repositorio privado en GitHub

1. Crear un repositorio **privado** y vacío llamado `web-francisco-recaite` (sin README ni .gitignore).
2. Subir el contenido de esta carpeta a la rama `main`:

```bash
cd web-francisco-recaite
git init -b main
git add -A
git commit -m "Primera versión de la web"
git remote add origin https://github.com/USUARIO/web-francisco-recaite.git
git push -u origin main
```

## 2. Publicar en Vercel

1. En vercel.com (cuenta de Francisco), **Add New › Project**.
2. Importar el repositorio `web-francisco-recaite`.
3. Framework Preset: **Other**. Build Command y Output Directory: vacíos.
4. **Deploy**.

Cada cambio que se suba a `main` se publica solo.

## 3. Encuestas (Supabase)

Ya está todo configurado; no hay que tocar nada.

- Proyecto de Supabase: **web-francisco-recaite** (organización de Vercel de Francisco, región París).
- URL: `https://iayhiustzvtzyhtpuutj.supabase.co`
- La web usa la **clave pública** (`sb_publishable_…`), que ya está en `index.html`. Es normal que sea visible: solo permite enviar respuestas y leer porcentajes.
- Los visitantes **no pueden leer** respuestas individuales ni comentarios.

**Comprobación tras publicar:** abrir un artículo de la sección Ideas, responder la encuesta y comprobar que aparecen los porcentajes. Después, en Supabase › Table Editor › `encuesta_respuestas`, debe verse la fila.

### Consultar los resultados

En Supabase › SQL Editor:

```sql
-- Porcentajes de un artículo
select public.encuesta_resultados('como-crece-malaga');

-- Número de personas que han respondido, por artículo
select slug, count(distinct respondent) as personas
from public.encuesta_respuestas group by slug order by personas desc;

-- Comentarios libres (solo visibles desde aquí)
select slug, texto, created_at from public.encuesta_notas order by created_at desc;
```

Los identificadores de los artículos (`slug`) son: `comprar-terreno`, `disenar-para-el-calor`,
`casa-antes-del-plano`, `valor-mas-alla-de-los-m2`, `render-que-explica`, `ia-y-criterio`,
`cinco-usos-de-ia`, `mas-vivienda-mejor-ciudad`, `como-crece-malaga`, `de-la-idea-al-proyecto`.

## Pendiente antes de hacerla pública

- **Contacto:** el pie de la web todavía muestra "Pendiente: añadir email de contacto" y "Pendiente: añadir usuario" de Instagram. Buscar `class="todo"` en `index.html`.
- Revisar que todo el contenido puede ser público (en especial el proyecto de viviendas adosadas).
