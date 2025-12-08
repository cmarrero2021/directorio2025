<template>
  <q-page class="q-pa-md">
    <!-- Cabecera de la página -->
    <header class="page-header">
      <!-- Puedes agregar título aquí si es necesario -->
    </header>

    <!-- Sección de Filtros (Reemplaza al Drawer) -->
    <div class="filters-section q-mb-xl">
      <q-expansion-item icon="filter_list" label="Filtros de Búsqueda" header-class="text-primary text-weight-bold"
        expand-icon-class="text-primary">
        <div class="q-pa-md">
          <div class="row q-col-gutter-md q-mb-xl">
            <!-- Fila 1: Filtros principales (Selects) -->
            <div class="col-12 col-sm-6 col-md-3">
              <label class="text-caption text-weight-medium q-mb-xs block">Área de Conocimiento</label>
              <q-select v-model="filters.area_conocimiento" filled dense :options="filteredAreasOptions"
                option-value="value" option-label="label" emit-value map-options label="Seleccionar área" multiple
                use-chips clearable use-input input-debounce="300" @filter="filterAreas">
                <template v-slot:prepend>
                  <q-icon name="category" color="primary" />
                </template>
                <template v-slot:no-option>
                  <q-item>
                    <q-item-section class="text-grey">No hay resultados</q-item-section>
                  </q-item>
                </template>
              </q-select>
            </div>

            <div class="col-12 col-sm-6 col-md-3">
              <label class="text-caption text-weight-medium q-mb-xs block">Índice</label>
              <q-select v-model="filters.indice" filled dense :options="filteredIndicesOptions" option-value="value"
                option-label="label" emit-value map-options label="Seleccionar índice" multiple use-chips clearable
                use-input input-debounce="300" @filter="filterIndices">
                <template v-slot:prepend>
                  <q-icon name="list_alt" color="primary" />
                </template>
                <template v-slot:no-option>
                  <q-item>
                    <q-item-section class="text-grey">No hay resultados</q-item-section>
                  </q-item>
                </template>
              </q-select>
            </div>

            <div class="col-12 col-sm-6 col-md-3">
              <label class="text-caption text-weight-medium q-mb-xs block">Idioma</label>
              <q-select v-model="filters.idioma" filled dense :options="filteredIdiomasOptions" option-value="value"
                option-label="label" emit-value map-options label="Seleccionar idioma" multiple use-chips clearable
                use-input input-debounce="300" @filter="filterIdiomas">
                <template v-slot:prepend>
                  <q-icon name="language" color="primary" />
                </template>
                <template v-slot:no-option>
                  <q-item>
                    <q-item-section class="text-grey">No hay resultados</q-item-section>
                  </q-item>
                </template>
              </q-select>
            </div>

            <div class="col-12 col-sm-6 col-md-3">
              <label class="text-caption text-weight-medium q-mb-xs block">Editorial</label>
              <q-select v-model="filters.editorial" filled dense :options="filteredEditorialOptions"
                option-value="value" option-label="label" emit-value map-options label="Seleccionar editorial" multiple
                use-chips clearable use-input input-debounce="300" @filter="filterEditorial">
                <template v-slot:prepend>
                  <q-icon name="business" color="primary" />
                </template>
                <template v-slot:no-option>
                  <q-item>
                    <q-item-section class="text-grey">No hay resultados</q-item-section>
                  </q-item>
                </template>
              </q-select>
            </div>
          </div>

          <!-- Fila 2: Filtros secundarios (Selects) -->
          <div class="row q-col-gutter-md q-mb-xl">
            <div class="col-12 col-sm-6 col-md-3">
              <label class="text-caption text-weight-medium q-mb-xs block">Periodicidad</label>
              <q-select v-model="filters.periodicidad" filled dense :options="filteredPeriodicidadOptions"
                option-value="value" option-label="label" emit-value map-options label="Periodicidad" multiple use-chips
                clearable use-input input-debounce="300" @filter="filterPeriodicidad">
                <template v-slot:prepend>
                  <q-icon name="schedule" color="primary" />
                </template>
                <template v-slot:no-option>
                  <q-item>
                    <q-item-section class="text-grey">No hay resultados</q-item-section>
                  </q-item>
                </template>
              </q-select>
            </div>

            <div class="col-12 col-sm-6 col-md-3">
              <label class="text-caption text-weight-medium q-mb-xs block">Formato</label>
              <q-select v-model="filters.formato" filled dense :options="filteredFormatoOptions" option-value="value"
                option-label="label" emit-value map-options label="Formato" multiple use-chips clearable use-input
                input-debounce="300" @filter="filterFormato">
                <template v-slot:prepend>
                  <q-icon name="description" color="primary" />
                </template>
                <template v-slot:no-option>
                  <q-item>
                    <q-item-section class="text-grey">No hay resultados</q-item-section>
                  </q-item>
                </template>
              </q-select>
            </div>

            <div class="col-12 col-sm-6 col-md-3">
              <label class="text-caption text-weight-medium q-mb-xs block">Estado</label>
              <q-select v-model="filters.estado" filled dense :options="filteredEstadoOptions" option-value="value"
                option-label="label" emit-value map-options label="Estado" multiple use-chips clearable use-input
                input-debounce="300" @filter="filterEstado">
                <template v-slot:prepend>
                  <q-icon name="location_on" color="primary" />
                </template>
                <template v-slot:no-option>
                  <q-item>
                    <q-item-section class="text-grey">No hay resultados</q-item-section>
                  </q-item>
                </template>
              </q-select>
            </div>

            <div class="col-12 col-sm-6 col-md-3">
              <label class="text-caption text-weight-medium q-mb-xs block">ISSN Digital</label>
              <q-input v-model="filters.issn_digital" filled dense label="Buscar ISSN Digital" clearable>
                <template v-slot:prepend>
                  <q-icon name="search" color="primary" />
                </template>
              </q-input>
            </div>
          </div>

          <!-- Fila 3: Filtros de Texto (ISSN, Depósito) -->
          <div class="row q-col-gutter-md q-mb-xl">
            <div class="col-12 col-sm-6 col-md-3">
              <label class="text-caption text-weight-medium q-mb-xs block">ISSN Impreso</label>
              <q-input v-model="filters.issn_impreso" filled dense label="Buscar ISSN Impreso" clearable>
                <template v-slot:prepend>
                  <q-icon name="search" color="primary" />
                </template>
              </q-input>
            </div>
            <div class="col-12 col-sm-6 col-md-3">
              <label class="text-caption text-weight-medium q-mb-xs block">Depósito Legal Digital</label>
              <q-input v-model="filters.deposito_legal_digital" filled dense label="Buscar Depósito Digital" clearable>
                <template v-slot:prepend>
                  <q-icon name="search" color="primary" />
                </template>
              </q-input>
            </div>
            <div class="col-12 col-sm-6 col-md-3">
              <label class="text-caption text-weight-medium q-mb-xs block">Depósito Legal Impreso</label>
              <q-input v-model="filters.deposito_legal_impreso" filled dense label="Buscar Depósito Impreso" clearable>
                <template v-slot:prepend>
                  <q-icon name="search" color="primary" />
                </template>
              </q-input>
            </div>
            <div class="col-12 col-sm-6 col-md-3 flex items-end justify-end">
              <q-btn color="primary" icon="filter_alt_off" round @click="limpiarFiltros" :disable="!hasActiveFilters">
                <q-tooltip>Limpiar Filtros</q-tooltip>
              </q-btn>
            </div>
          </div>

          <!-- Indicador de filtros activos -->
          <div v-if="hasActiveFilters" class="q-mt-md">
            <q-chip v-if="filters.area_conocimiento && filters.area_conocimiento.length > 0" removable
              @remove="filters.area_conocimiento = []" color="primary" text-color="white" icon="category">
              Área: {{filters.area_conocimiento.map(v => v.label || v).join(', ')}}
            </q-chip>
            <q-chip v-if="filters.indice && filters.indice.length > 0" removable @remove="filters.indice = []"
              color="primary" text-color="white" icon="list_alt">
              Índice: {{filters.indice.map(v => v.label || v).join(', ')}}
            </q-chip>
            <q-chip v-if="filters.idioma && filters.idioma.length > 0" removable @remove="filters.idioma = []"
              color="primary" text-color="white" icon="language">
              Idioma: {{filters.idioma.map(v => v.label || v).join(', ')}}
            </q-chip>
            <q-chip v-if="filters.editorial && filters.editorial.length > 0" removable @remove="filters.editorial = []"
              color="primary" text-color="white" icon="business">
              Editorial: {{filters.editorial.map(v => v.label || v).join(', ')}}
            </q-chip>
            <q-chip v-if="filters.periodicidad && filters.periodicidad.length > 0" removable
              @remove="filters.periodicidad = []" color="primary" text-color="white" icon="schedule">
              Periodicidad: {{filters.periodicidad.map(v => v.label || v).join(', ')}}
            </q-chip>
            <q-chip v-if="filters.formato && filters.formato.length > 0" removable @remove="filters.formato = []"
              color="primary" text-color="white" icon="description">
              Formato: {{filters.formato.map(v => v.label || v).join(', ')}}
            </q-chip>
            <q-chip v-if="filters.estado && filters.estado.length > 0" removable @remove="filters.estado = []"
              color="primary" text-color="white" icon="location_on">
              Estado: {{filters.estado.map(v => v.label || v).join(', ')}}
            </q-chip>
            <q-chip v-if="filters.issn_digital" removable @remove="filters.issn_digital = ''" color="primary"
              text-color="white" icon="search">
              ISSN Digital: {{ filters.issn_digital }}
            </q-chip>
            <q-chip v-if="filters.issn_impreso" removable @remove="filters.issn_impreso = ''" color="primary"
              text-color="white" icon="search">
              ISSN Impreso: {{ filters.issn_impreso }}
            </q-chip>
            <q-chip v-if="filters.deposito_legal_digital" removable @remove="filters.deposito_legal_digital = ''"
              color="primary" text-color="white" icon="search">
              Depósito Digital: {{ filters.deposito_legal_digital }}
            </q-chip>
            <q-chip v-if="filters.deposito_legal_impreso" removable @remove="filters.deposito_legal_impreso = ''"
              color="primary" text-color="white" icon="search">
              Depósito Impreso: {{ filters.deposito_legal_impreso }}
            </q-chip>
          </div>
        </div>
      </q-expansion-item>
    </div>

    <!-- Contenido principal -->
    <main class="main-content">
      <!-- Tarjetas de Revistas -->
      <div class="revistas-container">
        <div v-if="filteredRevistas.length > 0">
          <div class="row q-gutter-xl justify-center">
            <q-card v-for="revista in paginatedRevistas" :key="revista.id" class="my-card col-md-3 col-sm-6 col-xs-12"
              @click="openDialog(revista)">
              <q-img :src="`${imageBaseUrl}${revista.portada}`" :alt="revista.portada" />
              <q-card-section>
              </q-card-section>
            </q-card>
          </div>
          <!-- Paginación -->
          <div class="q-mt-md flex flex-center">
            <q-pagination v-model="pagination.page" :max="totalPages" :max-pages="10" direction-links boundary-links
              class="q-mt-md flex flex-center" />
          </div>
        </div>
        <div v-else class="no-results">
          <p>No se encontraron revistas que coincidan con los filtros seleccionados.</p>
        </div>
      </div>
    </main>
    <!-- Diálogo para mostrar detalles -->
    <q-card-section class="scrollable-content" ref="dialogContent">
      <q-dialog v-model="dialogVisible" :maximized="isMaximized" transition-show="scale" transition-hide="fade">
        <q-card class="custom-dialog">
          <!-- Toolbar -->
          <q-toolbar class="bg-primary text-white">
            <q-toolbar-title class="text-center text-responsive">
              Directorio de Revistas Científicas - ONCTI
            </q-toolbar-title>
            <q-btn :icon="isMaximized ? 'fullscreen_exit' : 'fullscreen'" flat round dense @click="toggleMaximized"
              :title="isMaximized ? 'Salir de pantalla completa' : 'Pantalla completa'" />
            <q-btn icon="picture_as_pdf" :loading="loading" :disable="loading" flat round dense @click="exportToPdf"
              title="Exportar a PDF">
              <template v-slot:loading>
                <q-spinner-hourglass class="on-left" />
                Generando...
              </template>
            </q-btn>
            <q-btn icon="close" flat round dense @click="dialogVisible = false" />
          </q-toolbar>
          <!-- Contenido del diálogo con scroll -->
          <q-card-section class="scrollable-content" ref="dialogContent">
            <div>
              <div class="row justify-between items-center full-width q-px-md">
                <q-img src="img/logo-nobg1.png" style="width: 30%" />
                <q-img src="img/oncti-nobg.png" style="width: 10%" />
              </div>
              <!-- <div> -->
              <!-- <q-img src="img/oncti-nobg.png" style="width: 10%"/> -->
              <!-- <q-img src="img/cintillo.jpg" /> -->
              <!-- </div> -->
            </div>
            <div v-if="selectedRevista" class="row q-col-gutter-md" id="contenidoRevista">
              <!-- Columna de la Imagen -->
              <div class="col-xs-12 col-sm-4 col-md-4">
                <q-img :src="`${imageBaseUrl}${selectedRevista.portada}`" :alt="`Portada de ${selectedRevista.revista}`"
                  class="portada-img" style="height: 100%; object-fit: cover;" />
              </div>
              <!-- Columna de Información -->
              <div class="col-xs-12 col-sm-8 col-md-8">
                <div class="row q-col-gutter-sm">
                  <!-- Primera Columna -->
                  <div class="col-6">
                    <template v-for="(value, key, index) in Object.fromEntries(
                      Object.entries(selectedRevista).filter(([key]) => !['portada', 'resumen', 'id'].includes(key))
                    )" :key="key">
                      <div v-if="index < Math.ceil(Object.keys(Object.fromEntries(
                        Object.entries(selectedRevista).filter(([key]) => !['portada', 'resumen', 'id'].includes(key))
                      )).length / 2)" class="q-mb-sm">
                        <div class="etq">{{ key.toUpperCase().replace(/_/g, ' ') }}</div>
                        <div class="contenido">{{ value ?? '' }}</div>
                      </div>
                    </template>
                  </div>
                  <!-- Segunda Columna -->
                  <div class="col-6">
                    <template v-for="(value, key, index) in Object.fromEntries(
                      Object.entries(selectedRevista).filter(([key]) => !['portada', 'resumen', 'id'].includes(key))
                    )" :key="key">
                      <div v-if="index >= Math.ceil(Object.keys(Object.fromEntries(
                        Object.entries(selectedRevista).filter(([key]) => !['portada', 'resumen', 'id'].includes(key))
                      )).length / 2)" class="q-mb-sm">
                        <div class="etq">{{ key.toUpperCase().replace(/_/g, ' ') }}</div>
                        <div class="contenido">{{ value ?? '' }}</div>
                      </div>
                    </template>
                  </div>
                </div>
              </div>
            </div>
            <!-- Contenedor para el Resumen -->
            <div class="col-12 q-mt-lg">
              <div v-if="selectedRevista.resumen" class="resumen-container">
                <label class="etq">RESÚMEN</label>
                <div class="resumen-content" v-html="selectedRevista.resumen"></div>
              </div>
              <div v-else class="resumen-container">
                <label class="resumen-title">RESÚMEN</label>
                <div class="resumen-content"></div>
              </div>
            </div>
          </q-card-section>
        </q-card>
      </q-dialog>
    </q-card-section>
  </q-page>
</template>
<script setup>
import { ref, computed, onMounted, watch, nextTick } from "vue";
import axios from "axios";
import { Notify } from "quasar";
import html2canvas from "html2canvas";
import { jsPDF } from "jspdf";
import socket from "src/services/websocket.js";

const imageBaseUrl = ref("");
const revistas = ref([]);
const dialogContent = ref(null);
const isMaximized = ref(false);
const toggleMaximized = () => {
  isMaximized.value = !isMaximized.value;
};

// Filtros
const filters = ref({
  revista: "",
  area_conocimiento: [],
  indice: [],
  idioma: [],
  editorial: [],
  periodicidad: [],
  formato: [],
  estado: [],
  issn_digital: "",
  issn_impreso: "",
  deposito_legal_digital: "",
  deposito_legal_impreso: "",
});

const pagination = ref({
  page: 1,
  rowsPerPage: 10,
});
const dialogVisible = ref(false);
const selectedRevista = ref(null);

// Opciones originales
const areasConocimiento = ref([]);
const revistasIndices = ref([]);
const revistasIdiomas = ref([]);
const revistasEditorial = ref([]);
const revistasPeriodicidad = ref([]);
const revistasFormato = ref([]);
const revistasEstado = ref([]);

// Opciones filtradas para los selects
const filteredAreasOptions = ref([]);
const filteredIndicesOptions = ref([]);
const filteredIdiomasOptions = ref([]);
const filteredEditorialOptions = ref([]);
const filteredPeriodicidadOptions = ref([]);
const filteredFormatoOptions = ref([]);
const filteredEstadoOptions = ref([]);

const loading = ref(false);

// Watcher para controlar la paginación
watch(pagination, (newVal) => {
  if (newVal.page > totalPages.value) {
    pagination.value.page = Math.max(1, totalPages.value);
  }
}, { deep: true });

// Funciones de filtrado para los selects
const filterOptions = (val, update, originalOptions, filteredRef) => {
  update(() => {
    if (val === '') {
      filteredRef.value = originalOptions.value;
    } else {
      const needle = val.toLowerCase();
      filteredRef.value = originalOptions.value.filter(
        v => v.label.toLowerCase().indexOf(needle) > -1
      );
    }
  });
};

const filterAreas = (val, update) => filterOptions(val, update, areasConocimiento, filteredAreasOptions);
const filterIndices = (val, update) => filterOptions(val, update, revistasIndices, filteredIndicesOptions);
const filterIdiomas = (val, update) => filterOptions(val, update, revistasIdiomas, filteredIdiomasOptions);
const filterEditorial = (val, update) => filterOptions(val, update, revistasEditorial, filteredEditorialOptions);
const filterPeriodicidad = (val, update) => filterOptions(val, update, revistasPeriodicidad, filteredPeriodicidadOptions);
const filterFormato = (val, update) => filterOptions(val, update, revistasFormato, filteredFormatoOptions);
const filterEstado = (val, update) => filterOptions(val, update, revistasEstado, filteredEstadoOptions);

const limpiarFiltros = () => {
  filters.value = {
    revista: "",
    area_conocimiento: [],
    indice: [],
    idioma: [],
    editorial: [],
    periodicidad: [],
    formato: [],
    estado: [],
    issn_digital: "",
    issn_impreso: "",
    deposito_legal_digital: "",
    deposito_legal_impreso: "",
  };
};

const hasActiveFilters = computed(() => {
  const f = filters.value;
  return f.revista ||
    f.area_conocimiento.length > 0 ||
    f.indice.length > 0 ||
    f.idioma.length > 0 ||
    f.editorial.length > 0 ||
    f.periodicidad.length > 0 ||
    f.formato.length > 0 ||
    f.estado.length > 0 ||
    f.issn_digital ||
    f.issn_impreso ||
    f.deposito_legal_digital ||
    f.deposito_legal_impreso;
});

// Obtener datos de la API
onMounted(async () => {
  try {
    const apiUrl = import.meta.env.VITE_API_URL;
    const response = await axios.get(apiUrl);
    revistas.value = response.data;
    imageBaseUrl.value = import.meta.env.VITE_IMAGE_BASE_URL;
  } catch (error) {
    console.error("Error fetching data:", error);
  }

  // Cargar opciones y asignar a filtered también
  const loadOptions = async (url, refVar, filteredRef) => {
    try {
      const res = await axios.get(url);
      // Detectar el nombre de la propiedad dinámicamente o hardcodear según el endpoint
      // Simplificación: mapeo manual basado en lo que ya existía
      let data = res.data;
      let mapFn = item => ({ label: item.value, value: item.value }); // Default

      if (url.includes('areas')) {
        mapFn = item => ({ label: item.area_conocimiento, value: item.area_conocimiento });
      } else if (url.includes('indices')) {
        mapFn = item => ({ label: item.indice, value: item.indice });
      } else if (url.includes('idiomas')) {
        mapFn = item => ({ label: item.idioma, value: item.idioma });
      } else if (url.includes('editorial')) {
        mapFn = item => ({ label: item.editorial, value: item.editorial });
      } else if (url.includes('periodicidad')) {
        mapFn = item => ({ label: item.periodicidad, value: item.periodicidad });
      } else if (url.includes('formato')) {
        mapFn = item => ({ label: item.formato, value: item.formato });
      } else if (url.includes('estado')) {
        mapFn = item => ({ label: item.estado, value: item.estado });
      }

      refVar.value = data.map(mapFn);
      filteredRef.value = refVar.value;
    } catch (error) {
      console.error(`Error loading options from ${url}:`, error);
    }
  };

  await Promise.all([
    loadOptions(import.meta.env.VITE_AREASR_BASE_URL, areasConocimiento, filteredAreasOptions),
    loadOptions(import.meta.env.VITE_INDICESR_BASE_URL, revistasIndices, filteredIndicesOptions),
    loadOptions(import.meta.env.VITE_IDIOMASR_BASE_URL, revistasIdiomas, filteredIdiomasOptions),
    loadOptions(import.meta.env.VITE_EDITORIALR_BASE_URL, revistasEditorial, filteredEditorialOptions),
    loadOptions(import.meta.env.VITE_PERIODICIDADR_BASE_URL, revistasPeriodicidad, filteredPeriodicidadOptions),
    loadOptions(import.meta.env.VITE_FORMATOR_BASE_URL, revistasFormato, filteredFormatoOptions),
    loadOptions(import.meta.env.VITE_ESTADOR_BASE_URL, revistasEstado, filteredEstadoOptions),
  ]);

  // WebSocket: refrescar revistas al recibir mensaje
  socket.addEventListener("message", async () => {
    try {
      const apiUrl = import.meta.env.VITE_API_URL;
      const response = await axios.get(apiUrl);
      revistas.value = response.data;
      Notify.create({ message: "Contenido actualizado", color: "positive", timeout: 2000 });
    } catch (error) {
      console.error('Error en WebSocket:', error);
      Notify.create({ message: "Error al actualizar", color: "negative", timeout: 3000 });
    }
  });
});

const filteredRevistas = computed(() => {
  return revistas.value.filter((revista) => {
    if (!revista.portada) return false; // Nueva condición para portadas inválidas
    return (
      revista.revista.toLowerCase().includes(filters.value.revista.toLowerCase()) &&
      (filters.value.area_conocimiento.length === 0 ||
        filters.value.area_conocimiento.includes(revista.area_conocimiento)) &&
      (filters.value.indice.length === 0 ||
        filters.value.indice.includes(revista.indice)) &&
      (filters.value.idioma.length === 0 ||
        filters.value.idioma.includes(revista.idioma)) &&
      (filters.value.editorial.length === 0 ||
        filters.value.editorial.includes(revista.editorial)) &&
      (filters.value.periodicidad.length === 0 ||
        filters.value.periodicidad.includes(revista.periodicidad)) &&
      (filters.value.formato.length === 0 ||
        filters.value.formato.includes(revista.formato)) &&
      (filters.value.estado.length === 0 ||
        filters.value.estado.includes(revista.estado)) &&
      (filters.value.issn_digital === "" ||
        (revista.issn_digital && revista.issn_digital.toLowerCase().includes(filters.value.issn_digital.toLowerCase()))) &&
      (filters.value.issn_impreso === "" ||
        (revista.issn_impreso && revista.issn_impreso.toLowerCase().includes(filters.value.issn_impreso.toLowerCase()))) &&
      (filters.value.deposito_legal_digital === "" ||
        (revista.deposito_legal_digital && revista.deposito_legal_digital.toLowerCase().includes(filters.value.deposito_legal_digital.toLowerCase()))) &&
      (filters.value.deposito_legal_impreso === "" ||
        (revista.deposito_legal_impreso && revista.deposito_legal_impreso.toLowerCase().includes(filters.value.deposito_legal_impreso.toLowerCase())))
    );
  });
});
// Paginación
const paginatedRevistas = computed(() => {
  const start = (pagination.value.page - 1) * pagination.value.rowsPerPage;
  const end = start + pagination.value.rowsPerPage;
  return filteredRevistas.value.slice(start, end);
});
const totalPages = computed(() => {
  return Math.ceil(
    filteredRevistas.value.length / pagination.value.rowsPerPage
  );
});
// Abrir diálogo con los detalles de la revista
const openDialog = (revista) => {
  selectedRevista.value = revista;
  dialogVisible.value = true;
  // setTimeout(() => {
  //   const cintilloImage = document.querySelectorAll("img[src='img/cintillo.png']");
  //   cintilloImage.forEach(cintillo => {
  //     cintillo.style.display = 'none';
  //   });
  // }, 100);
};

// Generar PDF
const exportToPdf = async () => {
  loading.value = true;
  if (!selectedRevista.value) {
    Notify.create({
      message: "No hay datos disponibles para exportar.",
      color: "negative",
      timeout: 3000,
    });
    loading.value = false;
    return;
  }
  try {
    // Referencia al contenedor del diálogo
    if (!dialogContent.value) {
      console.error("El contenedor del diálogo no está disponible.");
      return;
    } else {
      // console.log(dialogContent.value)
    }
    // Acceder al nodo DOM real usando $el
    const dialogElement = dialogContent.value.$el;
    // Desactivar el scroll temporalmente para capturar todo el contenido
    const originalOverflow = dialogElement.style.overflow;
    dialogElement.style.overflow = "visible";
    // Usar html2canvas para capturar el contenido completo
    const canvas = await html2canvas(dialogElement, {
      scale: 2, // Aumenta la calidad de la imagen
      useCORS: true, // Permite cargar imágenes externas
    });
    // Ocultar el cintillo nuevamente después de capturar el contenido
    // Restaurar el scroll original
    dialogElement.style.overflow = originalOverflow;
    // Convertir el canvas a una imagen
    const imgData = canvas.toDataURL("image/png");
    // Crear el PDF
    const pdf = new jsPDF({
      orientation: "portrait",
      unit: "pt",
      format: "a4",
    });
    // Calcular las dimensiones del PDF
    const imgWidth = pdf.internal.pageSize.getWidth();
    const imgHeight = (canvas.height * imgWidth) / canvas.width;
    // Agregar la imagen al PDF
    pdf.addImage(imgData, "PNG", 0, 0, imgWidth, imgHeight);
    // Generar el nombre del archivo
    const now = new Date();
    const timestamp = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}${String(now.getDate()).padStart(2, '0')}_${String(now.getHours()).padStart(2, '0')}${String(now.getMinutes()).padStart(2, '0')}${String(now.getSeconds()).padStart(2, '0')}`;
    const fileName = `${timestamp}_${selectedRevista.value.revista.replace(/[^a-zA-Z0-9]/g, '_')}.pdf`;
    // Guardar el PDF
    pdf.save(fileName);
  } catch (error) {
    console.error("Error al generar el PDF:", error);
    Notify.create({
      message: "Error al generar el PDF",
      color: "negative",
      timeout: 3000,
    });
  } finally {
    loading.value = false;
  }
};
</script>
<style scoped>
.q-page {
  padding: 20px;
}

.page-header {
  text-align: center;
  margin-bottom: 30px;
}

.page-header h1 {
  color: #333;
  margin-bottom: 10px;
}

.page-header p {
  color: #666;
  font-size: 1.1em;
}

.main-content {
  display: flex;
  gap: 20px;
}

.revistas-container {
  flex: 1;
}

.my-card {
  width: 75%;
  max-width: 200px;
  cursor: pointer;
}

.my-card .q-img {
  height: 250px;
  object-fit: cover;
}

.my-card .text-h6 {
  font-size: 1.1em;
  margin-bottom: 5px;
}

.my-card .text-subtitle2 {
  font-size: 0.9em;
  color: #666;
  font-size: 0.9em;
  color: #666;
}

.my-card .text-caption {
  font-size: 0.8em;
  color: #888;
}

.q-pagination {
  margin-top: 20px;
}

.no-results {
  text-align: center;
  padding: 40px 20px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.no-results p {
  color: #666;
  font-size: 1.1em;
}

.custom-dialog {
  width: 100%;
  max-width: 1200px;
  margin: auto;
  position: relative;
  z-index: 7000;
  border-radius: 10px !important;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.q-dialog__inner--maximized .custom-dialog {
  width: 100% !important;
  height: 100% !important;
  max-width: none !important;
  border-radius: 0 !important;
  margin: 0 !important;
}

.scrollable-content {
  height: 100%;
  flex: 1;
  overflow-y: auto;
}

.portada-img {
  height: 200px;
  object-fit: cover;
}

.text-responsive {
  font-size: 1.2rem;
}

.etq {
  font-size: 10px;
  font-weight: bolder;
  color: rgb(7, 7, 185);
}

.contenido {
  font-size: 10px;
}

.q-field {
  margin-bottom: -25px;
  font-size: 10px;
  width: 100%;
}

.resumen-title {
  margin-bottom: 12px;
  font-size: 12px;
  font-weight: bold;
  color: #333;
}

.resumen-content {
  font-size: 10px;
  line-height: 1.6;
  color: #555;
  white-space: pre-wrap;
}

.scrollable-content {
  overflow-y: auto;
}

@media (max-width: 599px) {
  .text-responsive {
    font-size: 1rem;
  }

  .my-card {
    width: 75%;
    max-width: 200px;
    cursor: pointer;
  }

  .my-card .q-img {
    height: 300px;
    object-fit: cover;
  }
}

@media (max-width: 399px) {
  .text-responsive {
    font-size: 0.9rem;
  }
}

.block {
  display: block;
}

@media (max-width: 599px) {
  .filters-section {
    padding: 16px;
  }
}
</style>
