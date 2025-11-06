<template>
  <q-page class="stats-page">
    <div class="q-pa-md">
      <!-- Sección de Filtros -->
      <div class="filters-section">
        <div class="row q-col-gutter-md items-center">
          <div class="col-12 col-md-3">
            <label class="text-caption text-weight-medium q-mb-xs block">Fecha del registro</label>
            <q-input
              v-model="fechaInicio"
              filled
              dense
              type="date"
              label="Desde"
              :max="fechaFin"
            >
              <template v-slot:prepend>
                <q-icon name="event" color="primary" />
              </template>
            </q-input>
          </div>
          <div class="col-12 col-md-3">
            <label class="text-caption text-weight-medium q-mb-xs block" style="opacity: 0;">Hasta</label>
            <q-input
              v-model="fechaFin"
              filled
              dense
              type="date"
              label="Hasta"
              :min="fechaInicio"
            >
              <template v-slot:prepend>
                <q-icon name="event" color="primary" />
              </template>
            </q-input>
          </div>
          <div class="col-12 col-md-3">
            <label class="text-caption text-weight-medium q-mb-xs block">Todos los Estados</label>
            <q-select
              v-model="estadoSeleccionado"
              filled
              dense
              :options="estadosOptions"
              label="Seleccionar estado"
              clearable
            >
              <template v-slot:prepend>
                <q-icon name="location_on" color="primary" />
              </template>
            </q-select>
          </div>
          <div class="col-12 col-md-3 q-pt-md">
            <div class="row q-gutter-sm">
              <q-btn
                color="primary"
                label="Filtrar"
                icon="filter_list"
                @click="aplicarFiltros"
                class="col"
                unelevated
              />
              <q-btn
                color="secondary"
                label="Ver activos"
                icon="visibility"
                @click="verActivos"
                class="col"
                unelevated
              />
              <q-btn
                color="accent"
                icon="download"
                @click="descargarDatos"
                flat
                round
                dense
              >
                <q-tooltip>Descargar</q-tooltip>
              </q-btn>
            </div>
          </div>
        </div>
      </div>

      <!-- Tarjetas de Estadísticas Principales -->
      <div class="row q-col-gutter-md q-mb-md">
        <div v-for="(stat, index) in mainStats" :key="index" class="col-12 col-sm-6 col-md-4 col-lg">
          <div class="stat-card">
            <div class="stat-icon">
              <q-icon :name="stat.icon" />
            </div>
            <div class="stat-content">
              <div class="stat-label">{{ stat.label }}</div>
              <div class="stat-value">{{ stat.value }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Mapa de Venezuela con Distribución -->
      <div class="oncti-card q-pa-md q-mb-md">
        <MapComponent />
      </div>

      <!-- Gráficos -->
      <div class="row q-col-gutter-md">
        <!-- Gráfico 1: Áreas de Conocimiento -->
        <div class="col-12 col-md-6">
          <ChartComponent 
            title="REVISTAS POR ÁREA DE CONOCIMIENTO" 
            :endpoint="grAreasUrl" 
            dataKey="area_conocimiento"
            valueKey="cant_area" 
            :tableColumns="tableColumns1" 
          />
        </div>

        <!-- Gráfico 2: Índices -->
        <div class="col-12 col-md-6">
          <ChartComponent 
            title="REVISTAS POR ÍNDICE" 
            :endpoint="grIndicesUrl" 
            dataKey="indice" 
            valueKey="cant_inddice"
            :tableColumns="tableColumns2" 
          />
        </div>

        <!-- Gráfico 3: Idiomas -->
        <div class="col-12 col-md-6">
          <ChartComponent 
            title="REVISTAS POR IDIOMA" 
            :endpoint="grIdiomasUrl" 
            dataKey="idioma" 
            valueKey="cant_idioma"
            :tableColumns="tableColumns3" 
          />
        </div>

        <!-- Gráfico 4: Editoriales -->
        <div class="col-12 col-md-6">
          <ChartComponent 
            title="REVISTAS POR EDITORIAL" 
            :endpoint="grEditorialesUrl" 
            dataKey="editorial"
            valueKey="cant_editorial" 
            :tableColumns="tableColumns4" 
          />
        </div>

        <!-- Gráfico 5: Periodicidades -->
        <div class="col-12 col-md-6">
          <ChartComponent 
            title="REVISTAS POR PERIODICIDAD" 
            :endpoint="grPeriodicidadesUrl" 
            dataKey="periodicidad"
            valueKey="cant_periodicidad" 
            :tableColumns="tableColumns5" 
          />
        </div>

        <!-- Gráfico 6: Formatos -->
        <div class="col-12 col-md-6">
          <ChartComponent 
            title="REVISTAS POR FORMATO" 
            :endpoint="grFormatosUrl" 
            dataKey="formato" 
            valueKey="cant_formato"
            :tableColumns="tableColumns6" 
          />
        </div>

        <!-- Gráfico 7: Estados -->
        <div class="col-12 col-md-6">
          <ChartComponent 
            title="REVISTAS POR ESTADO" 
            :endpoint="grEstadosUrl" 
            dataKey="estado" 
            valueKey="cant_estado"
            :tableColumns="tableColumns7" 
          />
        </div>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from "vue";
import { Notify } from "quasar";
import axios from "axios";
import ChartComponent from "src/components/ChartComponent.vue";
import MapComponent from 'src/components/MapComponent.vue';
import socket from "src/services/websocket.js";

// Variables de entorno
const grAreasUrl = import.meta.env.VITE_GR_AREAS_URL;
const grIndicesUrl = import.meta.env.VITE_GR_INDICES_URL;
const grIdiomasUrl = import.meta.env.VITE_GR_IDIOMAS_URL;
const grEditorialesUrl = import.meta.env.VITE_GR_EDITORIALES_URL;
const grPeriodicidadesUrl = import.meta.env.VITE_GR_PERIODICIDADES_URL;
const grFormatosUrl = import.meta.env.VITE_GR_FORMATOS_URL;
const grEstadosUrl = import.meta.env.VITE_GR_ESTADOS_URL;

// Variables reactivas para filtros
const fechaInicio = ref('2001-04-10');
const fechaFin = ref('2025-11-06');
const estadoSeleccionado = ref(null);

// Opciones de estados (se pueden cargar dinámicamente)
const estadosOptions = ref([
  'Amazonas', 'Anzoátegui', 'Apure', 'Aragua', 'Barinas', 'Bolívar', 
  'Carabobo', 'Cojedes', 'Delta Amacuro', 'Distrito Capital', 'Falcón', 
  'Guárico', 'Lara', 'Mérida', 'Miranda', 'Monagas', 'Nueva Esparta', 
  'Portuguesa', 'Sucre', 'Táchira', 'Trujillo', 'Vargas', 'Yaracuy', 'Zulia'
]);

// Variables reactivas para las estadísticas principales
const data = ref({});

// Estadísticas principales computadas
const mainStats = computed(() => [
  {
    icon: 'menu_book',
    label: getCustomTitle('revistas', data.value.revistas),
    value: data.value.revistas || 0
  },
  {
    icon: 'category',
    label: getCustomTitle('cant_area', data.value.cant_area),
    value: data.value.cant_area || 0
  },
  {
    icon: 'list_alt',
    label: getCustomTitle('cant_indices', data.value.cant_indices),
    value: data.value.cant_indices || 0
  },
  {
    icon: 'language',
    label: getCustomTitle('cant_idiomas', data.value.cant_idiomas),
    value: data.value.cant_idiomas || 0
  },
  {
    icon: 'business',
    label: getCustomTitle('cant_editoriales', data.value.cant_editoriales),
    value: data.value.cant_editoriales || 0
  }
]);

// Mapeo de claves a títulos personalizados
const customTitles = {
  revistas: "REVISTAS REGISTRADAS",
  cant_area: "ÁREAS DE CONOCIMIENTO",
  cant_indices: "ÍNDICES",
  cant_idiomas: "IDIOMAS",
  cant_editoriales: "EDITORIALES",
};

const customTitles1 = {
  revistas: "REVISTA REGISTRADA",
  cant_area: "ÁREA DE CONOCIMIENTO",
  cant_indices: "ÍNDICE",
  cant_idiomas: "IDIOMA",
  cant_editoriales: "EDITORIAL",
};

// Función para obtener los datos desde la API
const fetchData = async () => {
  try {
    const timestamp = new Date().getTime();
    const url = `http://poi-r.vps.co.ve:3000/cantidades?_t=${timestamp}`;
    const response = await axios.get(url);
    const newData = response.data[0];
    Object.keys(newData).forEach((key) => {
      data.value[key] = newData[key];
    });
  } catch (error) {
    console.error("Error al obtener los datos:", error);
    Notify.create({
      message: "Error al obtener los datos.",
      color: "negative",
      position: "top",
      timeout: 3000,
    });
  }
};

// Función para obtener el título personalizado basado en el valor
const getCustomTitle = (key, value) => {
  if (value === "1" || value === 1) {
    return customTitles1[key] || formatKey(key);
  } else {
    return customTitles[key] || formatKey(key);
  }
};

// Función para formatear las claves del objeto (fallback)
const formatKey = (key) => key.replace(/_/g, " ").replace(/\b\w/g, (char) => char.toUpperCase());

// Funciones de los botones de filtros
const aplicarFiltros = () => {
  Notify.create({
    message: "Filtros aplicados",
    color: "positive",
    position: "top",
    timeout: 2000,
  });
  // Aquí puedes implementar la lógica de filtrado
};

const verActivos = () => {
  Notify.create({
    message: "Mostrando registros activos",
    color: "info",
    position: "top",
    timeout: 2000,
  });
  // Aquí puedes implementar la lógica para ver activos
};

const descargarDatos = () => {
  Notify.create({
    message: "Descargando datos...",
    color: "primary",
    position: "top",
    timeout: 2000,
  });
  // Aquí puedes implementar la lógica de descarga
};

// Columnas de las tablas
const tableColumns1 = [
  { name: 'area_conocimiento', label: 'Área de Conocimiento', field: 'area_conocimiento', align: 'left' },
  { name: 'cant_area', label: 'Cantidad', field: 'cant_area' },
];

const tableColumns2 = [
  { name: 'indice', label: 'Índice', field: 'indice', align: 'left' },
  { name: 'cant_inddice', label: 'Cantidad', field: 'cant_inddice' },
];

const tableColumns3 = [
  { name: 'idioma', label: 'Idioma', field: 'idioma', align: 'left' },
  { name: 'cant_idioma', label: 'Cantidad', field: 'cant_idioma' },
];

const tableColumns4 = [
  { name: 'editorial', label: 'Editorial', field: 'editorial', align: 'left' },
  { name: 'cant_editorial', label: 'Cantidad', field: 'cant_editorial' },
];

const tableColumns5 = [
  { name: 'periodicidad', label: 'Periodicidad', field: 'periodicidad', align: 'left' },
  { name: 'cant_periodicidad', label: 'Cantidad', field: 'cant_periodicidad' },
];

const tableColumns6 = [
  { name: 'formato', label: 'Formato', field: 'formato', align: 'left' },
  { name: 'cant_formato', label: 'Cantidad', field: 'cant_formato' },
];

const tableColumns7 = [
  { name: 'estado', label: 'Estado', field: 'estado', align: 'left' },
  { name: 'cant_estado', label: 'Cantidad', field: 'cant_estado' },
];

// Ciclo de vida
onMounted(() => {
  fetchData();

  // Escuchar eventos del WebSocket
  socket.addEventListener("message", async (event) => {
    try {
      await fetchData();
    } catch (error) {
      console.error("Error al procesar la notificación:", error);
    }
  });
});

onUnmounted(() => {
  // Limpiar listeners si es necesario
});
</script>

<style scoped>
.block {
  display: block;
}

/* Ajustes adicionales para responsive */
@media (max-width: 599px) {
  .filters-section {
    padding: 16px;
  }
  
  .stat-card {
    margin-bottom: 12px;
  }
}

@media (min-width: 1024px) {
  .stat-card {
    min-width: 200px;
  }
}
</style>
