# Olist · E-commerce Analysis

Análisis del comportamiento de compra en Olist, un marketplace brasileño.  
**Stack:** Python · SQL · Tableau

---

## Objetivo

Responder una pregunta de negocio concreta:

> **¿Quién es el cliente de Olist, qué compra, cuándo lo compra y está satisfecho?**

El resultado es un dashboard interactivo que sintetiza los hallazgos en un solo vistazo.

---

## Dataset

- **Fuente:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)
- **Registros:** 99.441 pedidos entre 2016 y 2018
- **Tablas utilizadas:** `customers`, `orders`, `order_items`, `products`, `reviews`

---

## Flujo del proyecto

```
CSV originales → 01_limpieza_olist.ipynb
                        ↓
               02_creacion_tablas.sql   (Workbench)
                        ↓
               03_insercion_datos.ipynb
                        ↓
               04_consultas.sql         (Workbench)
                        ↓
               05_estadistica.ipynb
                        ↓
               Dashboard_Olist.twb      (Tableau)
```

---

## Estructura del repositorio

```
📁 olist/
├── data/                          → CSVs originales (no incluidos — ver Dataset)
├── output/                        → CSVs limpios (notebook 01) + CSV consolidado para Tableau (notebook 05)
├── sql_diagrama/                  → Diagrama entidad-relación de la base de datos
│   ├── ERR_diagram_olist.mwb      → Archivo editable (MySQL Workbench)
│   └── ERR_diagram_olist.pdf      → Versión exportada para consulta rápida
├── 01_limpieza_olist.ipynb        → Exploración y limpieza de las 5 tablas
├── 02_creacion_tablas.sql         → Esquema de la base de datos MySQL
├── 03_insercion_datos.ipynb       → Carga de los CSVs limpios en MySQL
├── 04_consultas.sql               → Consultas de análisis por pregunta de negocio
├── 05_estadistica.ipynb           → Estadística descriptiva + exportación a Tableau
├── Dashboard_Olist.twb            → Dashboard interactivo (requiere conexión MySQL)
├── NOTAS_PROCESO.md               → Registro técnico del proceso completo
└── requirements.txt               → Dependencias Python
```

Para reproducir el proyecto, descarga el dataset de Kaggle y coloca los CSV en `data/`. Los archivos de `output/` se generan ejecutando los notebooks en orden.

---

## Fases del proyecto

| Fase | Herramienta | Descripción |
|------|-------------|-------------|
| 1. Exploración y Limpieza | Python 
| 2. Creación de la Base de datos | SQL 
| 3. Análisis de las preguntas de negocio | SQL 
| 4. Estadística descriptiva de las variables importantes| Python 
| 5. Visualización de insights en un dashboard interactivo | Tableau 

---

## KPIs del dashboard

| KPI | Valor |
|-----|-------|
| Total de pedidos 
| Gasto típico por pedido 
| % Clientes satisfechos 

---

## Principales hallazgos

- **Geografía:** São Paulo, Río de Janeiro y Minas Gerais son las regiones que concentran más pedidos. 
- **Categorías:** Cama, Mesa y Baño; Belleza y Salud y Deportes y Ocio lideran las ventas por número de pedidos.
- **Temporalidad:** Los lunes son el día de mayor actividad de compra, con actividad descendente a lo largo de la semana — el sábado es el día de menor actividad. El negocio creció de forma sostenida.
- **Satisfacción:** La mayoría de clientes están satisfechos, solo un porcentaje pequeño no lo está.

---

## Cómo reproducir el proyecto

> ⚠️ Antes de empezar: el archivo `.env` con las credenciales MySQL ya está incluido en `.gitignore`. No lo subas a GitHub.

```bash
# 1. Clonar el repositorio
git clone https://github.com/usuario/olist.git
cd olist

# 2. Instalar dependencias
pip install -r requirements.txt

# 3. Crear el archivo .env con las credenciales MySQL
echo "MYSQL_HOST=localhost" > .env
echo "MYSQL_USER=tu_usuario" >> .env
echo "MYSQL_PASSWORD=tu_contraseña" >> .env

# 4. Descargar el dataset de Kaggle y colocar los CSV en data/

# 5. Ejecutar en orden:
#    01_limpieza_olist.ipynb
#    02_creacion_tablas.sql    (en MySQL Workbench)
#    03_insercion_datos.ipynb
#    04_consultas.sql          (en MySQL Workbench)
#    05_estadistica.ipynb

# 6. Abrir Dashboard_Olist.twb en Tableau Desktop
```

## Notas

Para más detalle sobre el proceso técnico paso a paso, consultar [`NOTAS_PROCESO.md`](./NOTAS_PROCESO.md).
