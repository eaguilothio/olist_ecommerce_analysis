# NOTAS_PROCESO — Olist

Registro técnico del proceso completo. Útil para replicar el proyecto o como referencia futura.

---

## Fase 1: Limpieza de datos

El notebook `01_limpieza_olist.ipynb` carga los CSV originales desde `data/` y genera los CSV limpios en `output/`. Los originales nunca se modifican.

**Esquema aplicado a cada tabla:** dimensión → información general → inspección → limpieza → guardar.

1. **Selección de tablas y columnas:** Solo se trabaja con lo que responde la pregunta de negocio. Todo lo demás se descarta antes de insertar en la base de datos — reduce ruido y simplifica el esquema.

2. **Filtro** Si ponemos un filtro como `order_status = 'delivered'` es la causa directa de las filas descartadas en la inserción.  

3. **Normalización de texto:** Todos los textos a minúsculas, sin espacios, con `_` como separador. Se aplica a nombres de columnas y a valores de tipo texto. Evita inconsistencias al cruzar tablas y mejora la legibilidad en el dashboard.

4. **Fechas:** Convertir con `pd.to_datetime()` antes de cualquier operación temporal. Sin conversión, las fechas son strings y no se pueden ordenar ni agrupar por mes o día de la semana.

5. **Nulos:** Con menos del 5% de nulos en una variable categórica, imputar con la moda es la opción más conservadora — no eliminamos filas. Con porcentajes mayores, valorar si tiene sentido imputar o descartar.

6. **Duplicados en `reviews`:** Cuando hay duplicados con criterio temporal, ordenar por fecha. `keep='last'` conserva el último por posición — si no se ordena primero, el resultado depende del orden original del archivo, que no está garantizado.

7. **Tipos al leer con pandas:** Aunque los CSV vengan limpios, `pd.read_csv()` puede inferir tipos incorrectamente — especialmente fechas, que lee como `object` por defecto. Verificar siempre con `df.info()` después de cada carga y convertir explícitamente antes de operar.

---

## Fase 2: Diagrama entidad-relación

Los archivos están en `sql_diagrama/` — el `.mwb` editable y el `.pdf` para consulta rápida.

8. **Cuándo hacerlo:** El diagrama se genera después de crear las tablas con `Database → Reverse Engineer` en MySQL Workbench. Sirve para verificar que las relaciones y claves foráneas son correctas antes de insertar datos.

---

## Fase 3: Base de datos MySQL

El archivo `02_creacion_tablas.sql` se ejecuta en MySQL Workbench antes de la inserción.

9. **Orden de creación:** Las claves foráneas obligan a un orden estricto — una tabla no puede referenciar otra que aún no existe: `customers · products → orders → order_items · reviews`

10. **`ON DELETE CASCADE`:** Si se elimina un registro padre, se eliminan automáticamente todos sus registros dependientes. Evita registros huérfanos sin necesidad de limpieza manual.

---

## Fase 4: Inserción de datos

El notebook `03_insercion_datos.ipynb` lee los CSV limpios de `output/` e inserta los datos en MySQL respetando el orden de las FK.

11. **Por qué Python y no el wizard de Workbench:** El Table Data Import Wizard requiere repetir el proceso manualmente tabla a tabla. Con Python la inserción completa se ejecuta en segundos con un solo click y cualquier error es trazable.

12. **`INSERT IGNORE`:** Descarta silenciosamente las filas que violan una restricción (como un filtro) sin interrumpir la inserción del resto. 

12. **Verificación post-inserción:** Comparar el número de filas del CSV con el recuento en MySQL para cada tabla. `diff = 0` confirma inserción completa. `diff > 0` indica filas descartadas por SQL — en este proyecto es comportamiento esperado, causado por el filtro de pedidos de la Fase 1.

---

## Fase 5: Consultas SQL

El archivo `04_consultas.sql` se ejecuta en MySQL Workbench. Responde las mismas preguntas que el dashboard.

13. **Media como aproximación a la mediana en SQL:** MySQL no tiene función nativa para calcular la mediana. Cuando la distribución tiene outliers, la media no es representativa — es una limitación del entorno, no del análisis. La mediana real se calcula en Python (notebook 05) y es la métrica que aparece en Tableau.

---

## Fase 6: Estadística descriptiva y exportación

El notebook `05_estadistica.ipynb` realiza el análisis estadístico y exporta el CSV que alimenta Tableau.

14. **Exportación desde Python:** Más fiable que el exportador de Workbench, que a veces trunca resultados con volúmenes grandes. El CSV consolidado `olist_tableau.csv` cruza las 5 tablas y es la única fuente de datos del dashboard.

---

## Fase 7: Dashboard en Tableau

El archivo `Dashboard_Olist.twb` requiere Tableau Desktop con conexión activa a MySQL.

> Para más detalle sobre la construcción del dashboard y las decisiones de diseño, consultar `tableau_chuleta.ipynb`.

15. **Estructura del dashboard:** KPIs en la parte superior. Gráficos agrupados por temática — una línea por tema (geografía, categorías, temporalidad, satisfacción). Diseño en modo flotante durante el desarrollo, convertido a mosaico para mayor estabilidad. Tamaño fijo al publicar para evitar desajustes en Tableau Public.

