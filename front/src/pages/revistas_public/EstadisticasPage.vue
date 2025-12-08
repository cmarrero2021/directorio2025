<template>
  <q-page class="stats-page">
    <div class="q-pa-md">
      <!-- Sección de Filtros -->
      <div class="filters-section">
        <q-expansion-item icon="filter_list" header-class="text-primary text-weight-bold"
          expand-icon-class="text-primary">
          <template v-slot:header>
            <q-item-section avatar>
              <q-icon name="filter_list" color="primary" />
            </q-item-section>
            <q-item-section>
              <span class="text-primary text-weight-bold">Filtros de Búsqueda</span>
            </q-item-section>
            <q-item-section side>
              <q-btn color="primary" icon="filter_alt_off" round flat @click.stop="limpiarFiltros"
                :disable="!filtersStore.hasActiveFilters()" size="sm" class="q-mr-sm">
                <q-tooltip>Limpiar Filtros</q-tooltip>
              </q-btn>
            </q-item-section>
          </template>
          <div class="q-pa-md">
            <div class="row q-col-gutter-md q-mb-md">
              <!-- Fila 1: Filtros principales -->
              <div class="col-12 col-sm-6 col-md-3">
                <label class="text-caption text-weight-medium q-mb-xs block">Área de Conocimiento</label>
                <q-select v-model="filtersStore.selectedArea" filled dense :options="filteredAreasOptions"
                  option-value="area_conocimiento" option-label="area_conocimiento" emit-value map-options
                  label="Seleccionar área" clearable use-input input-debounce="300" @filter="filterAreas"
                  @update:model-value="aplicarFiltros">
                  <template v-slot:prepend>
                    <q-icon name="category" color="primary" />
                  </template>
                  <template v-slot:no-option>
                    <q-item>
                      <q-item-section class="text-grey">
                        No hay resultados
                      </q-item-section>
                    </q-item>
                  </template>
                </q-select>
              </div>

              <div class="col-12 col-sm-6 col-md-3">
                <label class="text-caption text-weight-medium q-mb-xs block">Índice</label>
                <q-select v-model="filtersStore.selectedIndice" filled dense :options="filteredIndicesOptions"
                  option-value="indice" option-label="indice" emit-value map-options label="Seleccionar índice"
                  clearable use-input input-debounce="300" @filter="filterIndices" @update:model-value="aplicarFiltros">
                  <template v-slot:prepend>
                    <q-icon name="list_alt" color="primary" />
                  </template>
                  <template v-slot:no-option>
                    <q-item>
                      <q-item-section class="text-grey">
                        No hay resultados
                      </q-item-section>
                    </q-item>
                  </template>
                </q-select>
              </div>

              <div class="col-12 col-sm-6 col-md-3">
                <label class="text-caption text-weight-medium q-mb-xs block">Idioma</label>
                <q-select v-model="filtersStore.selectedIdioma" filled dense :options="filteredIdiomasOptions"
                  option-value="idioma" option-label="idioma" emit-value map-options label="Seleccionar idioma"
                  clearable use-input input-debounce="300" @filter="filterIdiomas" @update:model-value="aplicarFiltros">
                  <template v-slot:prepend>
                    <q-icon name="language" color="primary" />
                  </template>
                  <template v-slot:no-option>
                    <q-item>
                      <q-item-section class="text-grey">
                        No hay resultados
                      </q-item-section>
                    </q-item>
                  </template>
                </q-select>
              </div>

              <div class="col-12 col-sm-6 col-md-3">
                <label class="text-caption text-weight-medium q-mb-xs block">Editorial</label>
                <q-select v-model="filtersStore.selectedEditorial" filled dense :options="filteredEditorialesOptions"
                  option-value="editorial" option-label="editorial" emit-value map-options label="Seleccionar editorial"
                  clearable use-input input-debounce="300" @filter="filterEditoriales"
                  @update:model-value="aplicarFiltros">
                  <template v-slot:prepend>
                    <q-icon name="business" color="primary" />
                  </template>
                  <template v-slot:no-option>
                    <q-item>
                      <q-item-section class="text-grey">
                        No hay resultados
                      </q-item-section>
                    </q-item>
                  </template>
                </q-select>
              </div>
            </div>

            <!-- Fila 2: Filtros secundarios y acciones -->
            <div class="row q-col-gutter-md items-end">
              <div class="col-12 col-sm-6 col-md-2">
                <label class="text-caption text-weight-medium q-mb-xs block">Periodicidad</label>
                <q-select v-model="filtersStore.selectedPeriodicidad" filled dense
                  :options="filteredPeriodicidadOptions" option-value="periodicidad" option-label="periodicidad"
                  emit-value map-options label="Periodicidad" clearable use-input input-debounce="300"
                  @filter="filterPeriodicidad" @update:model-value="aplicarFiltros">
                  <template v-slot:prepend>
                    <q-icon name="schedule" color="primary" />
                  </template>
                  <template v-slot:no-option>
                    <q-item>
                      <q-item-section class="text-grey">
                        No hay resultados
                      </q-item-section>
                    </q-item>
                  </template>
                </q-select>
              </div>

              <div class="col-12 col-sm-6 col-md-2">
                <label class="text-caption text-weight-medium q-mb-xs block">Formato</label>
                <q-select v-model="filtersStore.selectedFormato" filled dense :options="filteredFormatosOptions"
                  option-value="formato" option-label="formato" emit-value map-options label="Formato" clearable
                  use-input input-debounce="300" @filter="filterFormatos" @update:model-value="aplicarFiltros">
                  <template v-slot:prepend>
                    <q-icon name="description" color="primary" />
                  </template>
                  <template v-slot:no-option>
                    <q-item>
                      <q-item-section class="text-grey">
                        No hay resultados
                      </q-item-section>
                    </q-item>
                  </template>
                </q-select>
              </div>

              <div class="col-12 col-sm-6 col-md-2">
                <label class="text-caption text-weight-medium q-mb-xs block">Estado</label>
                <q-select v-model="filtersStore.selectedEstado" filled dense :options="filteredEstadosOptions"
                  option-value="value" option-label="label" emit-value map-options label="Estado" clearable use-input
                  input-debounce="300" @filter="filterEstados" @update:model-value="aplicarFiltros">
                  <template v-slot:prepend>
                    <q-icon name="location_on" color="primary" />
                  </template>
                  <template v-slot:no-option>
                    <q-item>
                      <q-item-section class="text-grey">
                        No hay resultados
                      </q-item-section>
                    </q-item>
                  </template>
                </q-select>
              </div>

              <div class="col-12 col-sm-6 col-md-6">
                <div class="row q-gutter-sm justify-end">
                  <q-btn color="accent" icon="download" flat round dense>
                    <q-tooltip>Descargar</q-tooltip>
                    <q-menu>
                      <q-list style="min-width: 150px">
                        <q-item clickable v-close-popup @click="descargarPNG">
                          <q-item-section avatar>
                            <q-icon name="image" color="primary" />
                          </q-item-section>
                          <q-item-section>PNG</q-item-section>
                        </q-item>
                        <q-item clickable v-close-popup @click="descargarPDF">
                          <q-item-section avatar>
                            <q-icon name="picture_as_pdf" color="negative" />
                          </q-item-section>
                          <q-item-section>PDF</q-item-section>
                        </q-item>
                      </q-list>
                    </q-menu>
                  </q-btn>
                </div>
              </div>
            </div>

            <!-- Indicador de filtros activos -->
            <div v-if="filtersStore.hasActiveFilters()" class="q-mt-md">
              <q-chip v-if="filtersStore.selectedArea" removable
                @remove="filtersStore.selectedArea = null; aplicarFiltros()" color="primary" text-color="white"
                icon="category">
                Área: {{ filtersStore.selectedArea }}
              </q-chip>
              <q-chip v-if="filtersStore.selectedIndice" removable
                @remove="filtersStore.selectedIndice = null; aplicarFiltros()" color="primary" text-color="white"
                icon="list_alt">
                Índice: {{ filtersStore.selectedIndice }}
              </q-chip>
              <q-chip v-if="filtersStore.selectedIdioma" removable
                @remove="filtersStore.selectedIdioma = null; aplicarFiltros()" color="primary" text-color="white"
                icon="language">
                Idioma: {{ filtersStore.selectedIdioma }}
              </q-chip>
              <q-chip v-if="filtersStore.selectedEditorial" removable
                @remove="filtersStore.selectedEditorial = null; aplicarFiltros()" color="primary" text-color="white"
                icon="business">
                Editorial: {{ filtersStore.selectedEditorial }}
              </q-chip>
              <q-chip v-if="filtersStore.selectedPeriodicidad" removable
                @remove="filtersStore.selectedPeriodicidad = null; aplicarFiltros()" color="primary" text-color="white"
                icon="schedule">
                Periodicidad: {{ filtersStore.selectedPeriodicidad }}
              </q-chip>
              <q-chip v-if="filtersStore.selectedFormato" removable
                @remove="filtersStore.selectedFormato = null; aplicarFiltros()" color="primary" text-color="white"
                icon="description">
                Formato: {{ filtersStore.selectedFormato }}
              </q-chip>
              <q-chip v-if="filtersStore.selectedEstado" removable
                @remove="filtersStore.selectedEstado = null; aplicarFiltros()" color="primary" text-color="white"
                icon="location_on">
                Estado: {{ filtersStore.selectedEstado }}
              </q-chip>
            </div>
          </div>
        </q-expansion-item>
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
          <ChartComponent title="Revistas por Área de Conocimiento" :endpoint="grAreasUrl" dataKey="area_conocimiento"
            valueKey="cant_area" :tableColumns="tableColumns1" />
        </div>

        <!-- Gráfico 2: Índices -->
        <div class="col-12 col-md-6">
          <ChartComponent title="Revistas por Índice" :endpoint="grIndicesUrl" dataKey="indice" valueKey="cant_inddice"
            :tableColumns="tableColumns2" />
        </div>

        <!-- Gráfico 3: Idiomas -->
        <div class="col-12 col-md-6">
          <ChartComponent title="Revistas por Idioma" :endpoint="grIdiomasUrl" dataKey="idioma" valueKey="cant_idioma"
            :tableColumns="tableColumns3" />
        </div>

        <!-- Gráfico 4: Editoriales -->
        <div class="col-12 col-md-6">
          <ChartComponent title="Revistas por Editorial" :endpoint="grEditorialesUrl" dataKey="editorial"
            valueKey="cant_editorial" :tableColumns="tableColumns4" />
        </div>

        <!-- Gráfico 5: Periodicidades -->
        <div class="col-12 col-md-6">
          <ChartComponent title="Revistas por Periodicidad" :endpoint="grPeriodicidadesUrl" dataKey="periodicidad"
            valueKey="cant_periodicidad" :tableColumns="tableColumns5" />
        </div>

        <!-- Gráfico 6: Formatos -->
        <div class="col-12 col-md-6">
          <ChartComponent title="Revistas por Formato" :endpoint="grFormatosUrl" dataKey="formato"
            valueKey="cant_formato" :tableColumns="tableColumns6" />
        </div>

        <!-- Gráfico 7: Estados -->
        <div class="col-12 col-md-6">
          <ChartComponent title="Revistas por Estado" :endpoint="grEstadosUrl" dataKey="estado" valueKey="cant_estado"
            :tableColumns="tableColumns7" />
        </div>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from "vue";
import { Notify } from "quasar";
import axios from "axios";
import html2canvas from "html2canvas";
import jsPDF from "jspdf";
import ChartComponent from "src/components/ChartComponent.vue";
import MapComponent from 'src/components/MapComponent.vue';
import socket from "src/services/websocket.js";
import { useFiltersStore } from "src/stores/filters";

// Store de filtros
const filtersStore = useFiltersStore();

// Variables de entorno
const grAreasUrl = import.meta.env.VITE_GR_AREAS_URL;
const grIndicesUrl = import.meta.env.VITE_GR_INDICES_URL;
const grIdiomasUrl = import.meta.env.VITE_GR_IDIOMAS_URL;
const grEditorialesUrl = import.meta.env.VITE_GR_EDITORIALES_URL;
const grPeriodicidadesUrl = import.meta.env.VITE_GR_PERIODICIDADES_URL;
const grFormatosUrl = import.meta.env.VITE_GR_FORMATOS_URL;
const grEstadosUrl = import.meta.env.VITE_GR_ESTADOS_URL;

// URLs para listas de opciones
const listaAreasUrl = import.meta.env.VITE_LISTA_AREAS_URL;
const listaIndicesUrl = import.meta.env.VITE_LISTA_INDICES_URL;
const listaIdiomasUrl = import.meta.env.VITE_LISTA_IDIOMAS_URL;
const listaEditorialesUrl = import.meta.env.VITE_LISTA_EDITORIALES_URL;
const listaPeriodicidadUrl = import.meta.env.VITE_LISTA_PERIODICIDAD_URL;
const listaFormatosUrl = import.meta.env.VITE_LISTA_FORMATOS_URL;
const listaEstadosUrl = import.meta.env.VITE_LISTA_ESTADOS_URL;

// Opciones para los filtros (originales)
const areasOptions = ref([]);
const indicesOptions = ref([]);
const idiomasOptions = ref([]);
const editorialesOptions = ref([]);
const periodicidadOptions = ref([]);
const formatosOptions = ref([]);
const estadosOptions = ref([]);

// Opciones filtradas para autocompletado
const filteredAreasOptions = ref([]);
const filteredIndicesOptions = ref([]);
const filteredIdiomasOptions = ref([]);
const filteredEditorialesOptions = ref([]);
const filteredPeriodicidadOptions = ref([]);
const filteredFormatosOptions = ref([]);
const filteredEstadosOptions = ref([]);

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

// Función para cargar las opciones de los filtros (solo valores en uso)
const cargarOpcionesFiltros = async () => {
  try {
    const [areas, indices, idiomas, editoriales, periodicidad, formatos, estados] = await Promise.all([
      axios.get(listaAreasUrl),
      axios.get(listaIndicesUrl),
      axios.get(listaIdiomasUrl),
      axios.get(listaEditorialesUrl),
      axios.get(listaPeriodicidadUrl),
      axios.get(listaFormatosUrl),
      axios.get(listaEstadosUrl)
    ]);

    areasOptions.value = areas.data;
    indicesOptions.value = indices.data;
    idiomasOptions.value = idiomas.data;
    editorialesOptions.value = editoriales.data;
    periodicidadOptions.value = periodicidad.data;
    formatosOptions.value = formatos.data;

    // Mantener estados con formato original pero agregar valor en minúsculas
    estadosOptions.value = estados.data.map(e => ({
      ...e,
      label: e.estado, // Mostrar en mayúsculas
      value: e.estado.toLowerCase() // Valor interno en minúsculas
    }));

    // Inicializar opciones filtradas con todas las opciones
    filteredAreasOptions.value = areasOptions.value;
    filteredIndicesOptions.value = indicesOptions.value;
    filteredIdiomasOptions.value = idiomasOptions.value;
    filteredEditorialesOptions.value = editorialesOptions.value;
    filteredPeriodicidadOptions.value = periodicidadOptions.value;
    filteredFormatosOptions.value = formatosOptions.value;
    filteredEstadosOptions.value = estadosOptions.value;
  } catch (error) {
    console.error("Error al cargar opciones de filtros:", error);
    Notify.create({
      message: "Error al cargar las opciones de filtros",
      color: "negative",
      position: "top",
      timeout: 3000,
    });
  }
};

// Funciones de filtrado para autocompletado
const filterAreas = (val, update) => {
  update(() => {
    if (val === '') {
      filteredAreasOptions.value = areasOptions.value;
    } else {
      const needle = val.toLowerCase();
      filteredAreasOptions.value = areasOptions.value.filter(
        v => v.area_conocimiento.toLowerCase().indexOf(needle) > -1
      );
    }
  });
};

const filterIndices = (val, update) => {
  update(() => {
    if (val === '') {
      filteredIndicesOptions.value = indicesOptions.value;
    } else {
      const needle = val.toLowerCase();
      filteredIndicesOptions.value = indicesOptions.value.filter(
        v => v.indice.toLowerCase().indexOf(needle) > -1
      );
    }
  });
};

const filterIdiomas = (val, update) => {
  update(() => {
    if (val === '') {
      filteredIdiomasOptions.value = idiomasOptions.value;
    } else {
      const needle = val.toLowerCase();
      filteredIdiomasOptions.value = idiomasOptions.value.filter(
        v => v.idioma.toLowerCase().indexOf(needle) > -1
      );
    }
  });
};

const filterEditoriales = (val, update) => {
  update(() => {
    if (val === '') {
      filteredEditorialesOptions.value = editorialesOptions.value;
    } else {
      const needle = val.toLowerCase();
      filteredEditorialesOptions.value = editorialesOptions.value.filter(
        v => v.editorial.toLowerCase().indexOf(needle) > -1
      );
    }
  });
};

const filterPeriodicidad = (val, update) => {
  update(() => {
    if (val === '') {
      filteredPeriodicidadOptions.value = periodicidadOptions.value;
    } else {
      const needle = val.toLowerCase();
      filteredPeriodicidadOptions.value = periodicidadOptions.value.filter(
        v => v.periodicidad.toLowerCase().indexOf(needle) > -1
      );
    }
  });
};

const filterFormatos = (val, update) => {
  update(() => {
    if (val === '') {
      filteredFormatosOptions.value = formatosOptions.value;
    } else {
      const needle = val.toLowerCase();
      filteredFormatosOptions.value = formatosOptions.value.filter(
        v => v.formato.toLowerCase().indexOf(needle) > -1
      );
    }
  });
};

const filterEstados = (val, update) => {
  update(() => {
    if (val === '') {
      filteredEstadosOptions.value = estadosOptions.value;
    } else {
      const needle = val.toLowerCase();
      filteredEstadosOptions.value = estadosOptions.value.filter(
        v => v.label.toLowerCase().indexOf(needle) > -1
      );
    }
  });
};

// Función para aplicar filtros
const aplicarFiltros = () => {
  console.log("Filtros aplicados:", filtersStore.getActiveFilters());
  // Los gráficos se actualizarán automáticamente al cambiar los filtros
  // ya que están observando el store
};

// Función para limpiar todos los filtros
const limpiarFiltros = () => {
  filtersStore.clearAllFilters();
  Notify.create({
    message: "Filtros limpiados",
    color: "info",
    position: "top",
    timeout: 2000,
  });
};

const descargarPNG = async () => {
  try {
    Notify.create({
      message: "Generando imagen PNG...",
      color: "primary",
      position: "top",
      timeout: 2000,
    });

    await new Promise(resolve => setTimeout(resolve, 300));

    const pageElement = document.querySelector('.stats-page');

    if (!pageElement) {
      throw new Error('No se encontró el elemento de la página');
    }

    const canvas = await html2canvas(pageElement, {
      scale: 2,
      useCORS: true,
      logging: false,
      backgroundColor: '#F5F5F5',
      windowWidth: pageElement.scrollWidth,
      windowHeight: pageElement.scrollHeight,
      scrollY: -window.scrollY,
      scrollX: -window.scrollX,
    });

    canvas.toBlob((blob) => {
      if (!blob) {
        throw new Error('Error al generar la imagen');
      }

      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      const timestamp = new Date().toISOString().slice(0, 19).replace(/:/g, '-');
      link.download = `estadisticas-oncti-${timestamp}.png`;
      link.href = url;

      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(url);

      Notify.create({
        message: "PNG descargado exitosamente",
        color: "positive",
        position: "top",
        timeout: 2000,
        icon: "check_circle"
      });
    }, 'image/png');

  } catch (error) {
    console.error("Error al descargar PNG:", error);
    Notify.create({
      message: "Error al generar la imagen PNG",
      color: "negative",
      position: "top",
      timeout: 3000,
    });
  }
};

const descargarPDF = async () => {
  try {
    Notify.create({
      message: "Generando documento PDF...",
      color: "primary",
      position: "top",
      timeout: 2000,
    });

    await new Promise(resolve => setTimeout(resolve, 300));

    const pageElement = document.querySelector('.stats-page');

    if (!pageElement) {
      throw new Error('No se encontró el elemento de la página');
    }

    const canvas = await html2canvas(pageElement, {
      scale: 2,
      useCORS: true,
      logging: false,
      backgroundColor: '#F5F5F5',
      windowWidth: pageElement.scrollWidth,
      windowHeight: pageElement.scrollHeight,
      scrollY: -window.scrollY,
      scrollX: -window.scrollX,
    });

    const imgWidth = canvas.width;
    const imgHeight = canvas.height;

    const pdf = new jsPDF({
      orientation: imgWidth > imgHeight ? 'landscape' : 'portrait',
      unit: 'px',
      format: [imgWidth, imgHeight]
    });

    const imgData = canvas.toDataURL('image/png');
    pdf.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight);

    const timestamp = new Date().toISOString().slice(0, 19).replace(/:/g, '-');
    pdf.save(`estadisticas-oncti-${timestamp}.pdf`);

    Notify.create({
      message: "PDF descargado exitosamente",
      color: "positive",
      position: "top",
      timeout: 2000,
      icon: "check_circle"
    });

  } catch (error) {
    console.error("Error al descargar PDF:", error);
    Notify.create({
      message: "Error al generar el documento PDF",
      color: "negative",
      position: "top",
      timeout: 3000,
    });
  }
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
onMounted(async () => {
  await fetchData();
  await cargarOpcionesFiltros();

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
