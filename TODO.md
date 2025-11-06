# Plan de Rediseño Visual - EstadisticasPage

## Objetivo
Mejorar el aspecto visual de la página de estadísticas para que se parezca a la imagen del dashboard ONCTI, manteniendo toda la funcionalidad actual y asegurando diseño responsive.

## Tareas

### 1. Estilos Globales
- [x] Agregar variables CSS para colores ONCTI en app.scss
- [x] Definir estilos para tarjetas con sombras suaves
- [x] Configurar fondo gris claro

### 2. EstadisticasPage.vue
- [x] Agregar sección de filtros (fecha y estado) debajo del cintillo
- [x] Rediseñar tarjetas de estadísticas superiores con iconos
- [x] Reorganizar layout: Mapa con tabla lateral integrada
- [x] Mejorar grid de gráficos con mejor espaciado
- [x] Aplicar colores ONCTI
- [x] Asegurar diseño responsive (móvil, tablet, desktop)

### 3. ChartComponent.vue
- [x] Mejorar estilos de tarjetas de gráficos
- [x] Ajustar colores (azul y rosa según tipo de dato)
- [x] Mejorar toolbar de exportación
- [x] Optimizar gráficos donut y barras horizontales

### 4. MapComponent.vue
- [x] Mejorar integración de tabla lateral con mapa
- [x] Ajustar diseño responsive
- [x] Mejorar estilos visuales

### 5. Verificación Final
- [ ] Probar responsive en móvil
- [ ] Probar responsive en tablet
- [ ] Probar responsive en desktop
- [ ] Verificar funcionalidad de filtros
- [ ] Verificar funcionalidad de gráficos
- [ ] Verificar funcionalidad del mapa
- [ ] Verificar WebSocket updates

## Notas
- Mantener toda la funcionalidad actual
- Colores principales: Azul #273984 y Rosa/Rojo #FF6B9D
- Fondo: Gris claro #F5F5F5
