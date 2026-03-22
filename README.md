# Olist · E-commerce Analysis
**Stack:** Python · SQL · Tableau

---

## 🧩 Contexto / Problema

Olist es un marketplace brasileño que conecta pequeños vendedores en una misma plataforma online. Este proyecto surgió porque quería trabajar con un dataset real de e-commerce y responder una pregunta de negocio concreta:

> **¿Quién es el cliente de Olist, qué compra, cuándo lo compra y está satisfecho?**

---

## 📊 Datos

- **Fuente:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)
- **Volumen:** 99.441 pedidos entre 2016 y 2018
- **Tablas utilizadas:** `customers`, `orders`, `order_items`, `products`, `reviews`

---

## ⚙️ Proceso

## Fase 1: Limpieza de datos

El notebook `01_limpieza_olist.ipynb` carga los CSV originales desde `data/` y genera los CSV limpios en `output/`. Los originales nunca se modifican.

**Esquema aplicado a cada tabla:** dimensión → información general → inspección → limpieza → guardar.

- **Selección de tablas y columnas:** Solo se trabaja con lo que responde la pregunta de negocio. Todo lo demás se descarta — reduce ruido y simplifica el esquema.
- **Filtro de pedidos:** Solo se conservan los pedidos con `order_status = 'delivered'`. Los cancelados o en tránsito no tienen valoración del cliente y no son relevantes para el análisis.
- **Normalización de texto:** Todos los textos a minúsculas, sin espacios, con `_` como separador. Evita inconsistencias al cruzar tablas y mejora la legibilidad en el dashboard.
- **Nulos:** Con menos del 5% de nulos en una variable categórica, imputar con la moda es la opción más conservadora — no eliminamos filas.
- **Duplicados en reviews:** Un pedido puede tener más de una valoración. Se conserva la más reciente — se ordena por fecha antes de aplicar el filtro.

---

## Fase 2: Diagrama entidad-relación

Los archivos están en `sql_diagrama/` — el `.mwb` editable y el `.pdf` para consulta rápida.

- **Cómo se generó:** Primero se crean las tablas con `02_creacion_tablas.sql`, y después se genera el diagrama con `Database → Reverse Engineer` en MySQL Workbench. Sirve para verificar visualmente que las relaciones y claves foráneas son correctas antes de insertar datos.

---

## Fase 3: Base de datos MySQL

El archivo `02_creacion_tablas.sql` se ejecuta en MySQL Workbench antes de la inserción.

- **Orden de creación:** Las claves foráneas obligan a un orden estricto — una tabla no puede referenciar otra que aún no existe: `customers · products → orders → order_items · reviews`
- **`ON DELETE CASCADE`:** Si se elimina un registro padre, se eliminan automáticamente todos sus registros dependientes. Evita registros huérfanos sin necesidad de limpieza manual.

---

## Fase 4: Inserción de datos

El notebook `03_insercion_datos.ipynb` lee los CSV limpios de `output/` e inserta los datos en MySQL respetando el orden de las FK.

- **Por qué Python y no el wizard de Workbench:** El Table Data Import Wizard requiere repetir el proceso manualmente tabla a tabla. Con Python la inserción completa se ejecuta en segundos con un solo click y cualquier error es trazable.
- **Verificación post-inserción:** Comparar el número de filas del CSV con el recuento en MySQL para cada tabla. `diff = 0` confirma inserción completa. Las diferencias en `order_items` y `reviews` son comportamiento esperado — son registros que referencian pedidos descartados en la Fase 1 por no estar entregados.

---

## Fase 5: Consultas SQL

El archivo `04_consultas.sql` se ejecuta en MySQL Workbench. Responde las mismas preguntas que el dashboard.

- **Media como aproximación a la mediana en SQL:** MySQL no tiene función nativa para calcular la mediana. Cuando la distribución tiene outliers, la media no es representativa — es una limitación del entorno, no del análisis. La mediana real se calcula en Python (notebook 05) y es la métrica que aparece en Tableau.

---

## Fase 6: Estadística descriptiva y exportación

El notebook `05_estadistica.ipynb` realiza el análisis estadístico y exporta el CSV que alimenta Tableau.

- **Exportación desde Python:** Más fiable que el exportador de Workbench, que a veces trunca resultados con volúmenes grandes. El CSV consolidado `olist_tableau.csv` cruza las 5 tablas y es la única fuente de datos del dashboard.

---

## Fase 7: Dashboard en Tableau

El archivo `Dashboard_Olist.twb` requiere Tableau Desktop con conexión activa a MySQL.

> Para más detalle sobre la construcción del dashboard y las decisiones de diseño, consultar `tableau_chuleta.ipynb`.

- **Estructura del dashboard:** KPIs en la parte superior. Gráficos agrupados por temática — una línea por tema (geografía, categorías, temporalidad, satisfacción). Diseño en modo flotante durante el desarrollo, convertido a mosaico para mayor estabilidad. Tamaño fijo al publicar para evitar desajustes en Tableau Public.

---

## 💡 Principales hallazgos

- **Geografía:** SP, RJ y MG concentran la mayoría de pedidos. São Paulo representa casi la mitad del total.
- **Categorías:** Cama, mesa y baño; Belleza y salud; y Deportes y ocio lideran las ventas.
- **Temporalidad:** Los lunes son el día de mayor actividad. El negocio creció de forma sostenida entre 2016 y 2018.
- **Precio:** El gasto típico por pedido es ~80 BRL.
- **Satisfacción:** Satisfacción global alta (~80%), con Río de Janeiro por debajo (~70%).

Para el análisis detallado y las recomendaciones de negocio, ver `Recomendaciones_Olist.docx`.

---

## 🔍 Reflexión

El objetivo era practicar un flujo de trabajo completo: cada herramienta cumple un papel distinto. Esto añade más pasos; si se quisiera hacer un análisis más rápido, se podría haber usado Python como única herramienta.

Sin embargo, SQL es la herramienta más clara para trabajar con datos relacionales. Por su parte, Tableau es más adecuado que seaborn para visualizar los resultados (ya que es interactivo).

---


