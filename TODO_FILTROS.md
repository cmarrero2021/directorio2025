# TODO - Sistema de Filtros para Estadísticas

## Tareas Completadas ✅

### Backend
- [x] Crear endpoints en el backend con filtros acumulativos (AND)
  - [x] `/gr_areas_filtrado`
  - [x] `/gr_indices_filtrado`
  - [x] `/gr_idiomas_filtrado`
  - [x] `/gr_editoriales_filtrado`
  - [x] `/gr_periodicidades_filtrado`
  - [x] `/gr_formatos_filtrado`
  - [x] `/gr_estados_filtrado`
  - [x] Función helper `buildWhereClause()` para construir queries dinámicas

### Frontend - Stores
- [x] Crear store de Pinia para manejar el estado de los filtros (`front/src/stores/filters.js`)
  - [x] Estado reactivo para cada filtro
  - [x] Función `clearAllFilters()`
  - [x] Función `getActiveFilters()`
  - [x] Función `buildQueryString()`
  - [x] Función `hasActiveFilters()`

### Frontend - Componentes
- [x] Actualizar `EstadisticasPage.vue`:
  - [x] Reemplazar filtros de fecha por filtros de categorías
  - [x] Agregar selectores para: área, índice, idioma, editorial, periodicidad, formato, estado
  - [x] Implementar botón "Limpiar Filtros"
  - [x] Mostrar chips con filtros activos (removibles individualmente)
  - [x] Cargar opciones de filtros desde endpoints de listas
  - [x] Integrar con store de filtros

- [x] Actualizar `ChartComponent.vue`:
  - [x] Importar y usar `useFiltersStore`
  - [x] Usar endpoints filtrados cuando hay filtros activos
  - [x] Mantener compatibilidad con filtro de estado del mapa
  - [x] Watch para actualizar gráficos cuando cambien los filtros
  - [x] Lógica para construir URLs con filtros

- [x] Actualizar `MapComponent.vue`:
  - [x] Importar y usar `useFiltersStore`
  - [x] Sincronizar selección de estado con el store de filtros
  - [x] Actualizar mapa cuando cambien otros filtros (excluyendo estado)
  - [x] Watch para sincronizar filtro de estado bidireccional
  - [x] Usar endpoint filtrado para el mapa

### Variables de Entorno
- [x] Usuario agregó manualmente las variables en `.env.development` y `.env.production`

## Tareas Pendientes ⏳

### Testing
- [ ] **Probar filtros individuales**
  - [ ] Filtro de área
  - [ ] Filtro de índice
  - [ ] Filtro de idioma
  - [ ] Filtro de editorial
  - [ ] Filtro de periodicidad
  - [ ] Filtro de formato
  - [ ] Filtro de estado
  
- [ ] **Probar combinaciones de filtros múltiples**
  - [ ] 2 filtros simultáneos
  - [ ] 3+ filtros simultáneos
  - [ ] Todos los filtros activos
  
- [ ] **Verificar actualización de componentes**
  - [ ] Gráficos se actualizan correctamente
  - [ ] Mapa se actualiza correctamente
  - [ ] Tarjetas de estadísticas se actualizan
  
- [ ] **Probar interacciones**
  - [ ] Botón "Limpiar Filtros" funciona
  - [ ] Chips removibles funcionan
  - [ ] Click en mapa sincroniza con filtro de estado
  - [ ] Cambio de filtro de estado sincroniza con mapa
  
- [ ] **Verificar responsive**
  - [ ] Desktop (1920x1080)
  - [ ] Tablet (768x1024)
  - [ ] Móvil (375x667)
  
- [ ] **Probar casos edge**
  - [ ] Sin resultados para combinación de filtros
  - [ ] Filtros con caracteres especiales
  - [ ] Rendimiento con muchos filtros activos

### Documentación
- [ ] Documentar nuevos endpoints en README del backend
- [ ] Documentar estructura del store de filtros
- [ ] Agregar ejemplos de uso de filtros
- [ ] Documentar flujo de sincronización mapa-filtros

## Notas Técnicas 📝

### Endpoints Filtrados
Todos los endpoints `*_filtrado` aceptan los siguientes parámetros de query (opcionales):
- `estado` - Filtrar por estado
- `area` - Filtrar por área de conocimiento
- `indice` - Filtrar por índice
- `idioma` - Filtrar por idioma
- `editorial` - Filtrar por editorial
- `periodicidad` - Filtrar por periodicidad
- `formato` - Filtrar por formato

**Los filtros se aplican con lógica AND (acumulativa).**

### Endpoints de Listas
- `/lista_areas` - Lista de áreas de conocimiento
- `/lista_indices` - Lista de índices
- `/lista_idiomas` - Lista de idiomas
- `/lista_editoriales` - Lista de editoriales
- `/lista_periodicidad` - Lista de periodicidades
- `/lista_formatos` - Lista de formatos
- `/lista_estados` - Lista de estados

### Arquitectura de Filtros

```
┌─────────────────────────────────────────────────────────────┐
│                    EstadisticasPage.vue                      │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Filtros UI (q-select components)                      │ │
│  │  - Área, Índice, Idioma, Editorial, etc.              │ │
│  │  - Botón "Limpiar Filtros"                            │ │
│  │  - Chips de filtros activos                           │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
              ┌─────────────────────────┐
              │   useFiltersStore()     │
              │  (Pinia Store)          │
              │  - selectedArea         │
              │  - selectedIndice       │
              │  - selectedEstado       │
              │  - etc...               │
              └─────────────────────────┘
                     │              │
        ┌────────────┘              └────────────┐
        ▼                                        ▼
┌──────────────────┐                  ┌──────────────────┐
│ ChartComponent   │                  │  MapComponent    │
│  - Watch filters │                  │  - Watch filters │
│  - Build URL     │                  │  - Sync estado   │
│  - Fetch data    │                  │  - Update map    │
└──────────────────┘                  └──────────────────┘
        │                                        │
        ▼                                        ▼
┌──────────────────────────────────────────────────────────┐
│              Backend Endpoints                            │
│  /gr_areas_filtrado?area=X&indice=Y&estado=Z            │
│  /gr_estados_filtrado?area=X&indice=Y                   │
└──────────────────────────────────────────────────────────┘
```

### Sincronización Mapa-Filtros
- Click en mapa → Actualiza `filtersStore.selectedEstado`
- Cambio en filtro de estado → Actualiza `selectedStateStore.selectedState`
- Ambos stores se mantienen sincronizados bidireccional

## Archivos Modificados

### Backend
- `back/index.js` - Nuevos endpoints filtrados y función helper

### Frontend
- `front/src/stores/filters.js` - Nuevo store de Pinia
- `front/src/pages/revistas_public/EstadisticasPage.vue` - UI de filtros
- `front/src/components/ChartComponent.vue` - Integración con filtros
- `front/src/components/MapComponent.vue` - Sincronización con filtros

### Configuración
- `front/.env.development` - Nuevas variables de entorno (agregadas manualmente)
- `front/.env.production` - Nuevas variables de entorno (agregadas manualmente)
