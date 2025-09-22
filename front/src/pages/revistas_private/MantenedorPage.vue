<template>
  <div class="q-pa-md">
    <h4 class="q-mb-md">MANTENEDOR DE REVISTAS</h4>

    <q-table
      title="Lista de Revistas"
      :rows="filteredJournals"
      :columns="columns"
      :rows-per-page-options="[10, 20, 50]"
      row-key="id"
      :pagination="pagination"
      :loading="loading"
      virtual-scroll
      class="responsive-table"
    >
      <!-- Búsqueda general y botón borrar filtros -->
      <template v-slot:top>
        <!-- Primera fila: Búsqueda general y botón borrar filtros -->
        <div class="full-width row wrap items-center q-mb-md">
          <!-- Búsqueda general -->
          <div class="col-xs-10 col-sm-5 q-pr-xs">
            <q-input
              outlined
              dense
              debounce="300"
              v-model="searchQuery"
              label="Búsqueda general"
              placeholder="Buscar en todos los campos"
            >
              <template v-slot:append>
                <q-icon
                  v-if="searchQuery"
                  name="clear"
                  @click.stop="clearSearch"
                  class="cursor-pointer"
                  size="sm"
                />
              </template>
            </q-input>
          </div>

          <!-- Botón "Borrar todos los filtros" -->
          <div class="col-xs-2 col-sm-1">
            <q-btn
              icon="fas fa-trash"
              title="Borrar todos los filtros"
              @click="clearAllFilters"
              color="negative"
              flat
              size="sm"
              class="full-width"
            />
          </div>
        </div>

        <!-- Segunda fila: Filtros para las columnas -->
        <div
          class="full-width row wrap justify-between items-center content-center q-mb-md"
        >
          <div
            class="col-xs-12 col-sm-6 col-md-3 q-pa-sm"
            v-for="col in columns"
            :key="col.name"
          >
            <div v-if="col.filterable">
              <div v-if="col.type === 'select'">
                <q-select
                  :model-value="filters[col.name]"
                  @update:model-value="(val) => updateFilter(col.name, val)"
                  :options="getOptions(col.name)"
                  :label="col.label"
                  multiple
                  outlined
                  dense
                  use-chips
                  clearable
                >
                  <template v-slot:append>
                    <q-icon
                      v-if="filters[col.name] && filters[col.name].length > 0"
                      name="clear"
                      @click.stop="clearFilter(col.name)"
                      class="cursor-pointer"
                      size="sm"
                    />
                  </template>
                </q-select>
              </div>
              <div v-else>
                <q-input
                  :model-value="filters[col.name]"
                  @update:model-value="(val) => updateFilter(col.name, val)"
                  :label="col.label"
                  placeholder="Filtrar"
                  outlined
                  dense
                  debounce="300"
                >
                  <template v-slot:append>
                    <q-icon
                      v-if="filters[col.name]"
                      name="clear"
                      @click.stop="clearFilter(col.name)"
                      class="cursor-pointer"
                      size="sm"
                    />
                  </template>
                </q-input>
              </div>
            </div>
          </div>
        </div>
        <div class="col-xs-2 col-sm-1">
          <q-btn
            icon="add"
            title="Agregar nueva revista"
            @click="openNewModal"
            color="positive"
            size="sm"
            class="full-width"
          />
        </div>
      </template>

      <!-- Botones de acción en cada fila -->
      <template v-slot:body-cell-actions="props">
        <q-td>
          <div class="row items-center">
            <!-- Botón Editar -->
            <q-btn
              icon="edit"
              color="primary"
              title="Editar revista"
              size="xs"
              @click.stop="openEditModal(props.row)"
              class="q-mr-xs"
            />

            <!-- Botón Ver -->
            <q-btn
              icon="visibility"
              color="positive"
              title="Ver revista"
              size="xs"
              class="q-mr-xs"
            />

            <!-- Botón Borrar -->
            <q-btn
              icon="delete"
              color="negative"
              title="Eliminar Revista"
              size="xs"
              class="q-mr-xs"
            />
          </div>
        </q-td>
      </template>

      <!-- Estado de carga -->
      <template v-slot:loading>
        <q-inner-loading showing color="primary" />
      </template>
    </q-table>

    <!-- Modal de Edición -->
    <q-dialog v-model="editDialog" persistent>
      <q-card style="width: 700px; max-width: 80vw">
        <q-card-section>
          <div class="text-h6">
            {{ isEditing ? "Editar Revista" : "Nueva Revista" }}
          </div>
        </q-card-section>

        <q-card-section>
          <q-form @submit="saveChanges" class="q-gutter-md">
            <div class="row q-col-gutter-md">
              <!-- Campos del formulario -->
              <div class="col-12 col-md-6">
                <q-input v-model="editForm.id" label="ID" readonly filled />
              </div>
              <div class="col-12 col-md-6">
                <q-input
                  v-model="editForm.revista"
                  label="Revista"
                  filled
                  @input="editForm.revista = $event.toUpperCase()"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-select
                  v-model="editForm.area_conocimiento"
                  :options="optionsu.area_conocimiento"
                  label="Área de Conocimiento"
                  filled
                  option-label="label"
                  option-value="value"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-select
                  v-model="editForm.indice"
                  :options="optionsu.indice"
                  label="Índice"
                  filled
                  option-label="label"
                  option-value="value"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-select
                  v-model="editForm.idioma"
                  :options="optionsu.idioma"
                  label="Idioma"
                  filled
                  option-label="label"
                  option-value="value"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-input
                  v-model="editForm.correo_revista"
                  label="Correo de la Revista"
                  type="email"
                  filled
                />
              </div>
              <div class="col-12 col-md-6">
                <q-select
                  v-model="editForm.editorial"
                  :options="optionsu.editorial"
                  label="Editorial"
                  filled
                  option-label="label"
                  option-value="value"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-select
                  v-model="editForm.periodicidad"
                  :options="optionsu.periodicidad"
                  label="Periodicidad"
                  filled
                  option-label="label"
                  option-value="value"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-select
                  v-model="editForm.formato"
                  :options="optionsu.formato"
                  label="Formato"
                  filled
                  option-label="label"
                  option-value="value"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-select
                  v-model="editForm.estado"
                  :options="optionsu.estado"
                  label="Estado"
                  filled
                  option-label="label"
                  option-value="value"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-input
                  v-model="editForm.ciudad"
                  label="Ciudad"
                  filled
                  @input="editForm.ciudad = $event.toUpperCase()"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-input
                  v-model="editForm.nombres_editor"
                  label="Nombres del Editor"
                  filled
                  @input="editForm.nombres_editor = $event.toUpperCase()"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-input
                  v-model="editForm.apellidos_editor"
                  label="Apellidos del Editor"
                  filled
                  @input="editForm.apellidos_editor = $event.toUpperCase()"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-input
                  v-model="editForm.correo_editor"
                  label="Correo del Editor"
                  type="email"
                  filled
                />
              </div>
              <div class="col-12 col-md-6">
                <q-input
                  v-model="editForm.deposito_legal_impreso"
                  label="Depósito Legal Impreso"
                  filled
                  @input="
                    editForm.deposito_legal_impreso = $event.toUpperCase()
                  "
                />
              </div>
              <div class="col-12 col-md-6">
                <q-input
                  v-model="editForm.deposito_legal_digital"
                  label="Depósito Legal Digital"
                  filled
                  @input="
                    editForm.deposito_legal_digital = $event.toUpperCase()
                  "
                />
              </div>
              <div class="col-12 col-md-6">
                <q-input
                  v-model="editForm.issn_impreso"
                  label="ISSN Impreso"
                  filled
                  @input="editForm.issn_impreso = $event.toUpperCase()"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-input
                  v-model="editForm.issn_digital"
                  label="ISSN Digital"
                  filled
                  @input="editForm.issn_digital = $event.toUpperCase()"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-input v-model="editForm.url" label="URL" type="url" filled />
              </div>
              <div class="col-12 col-md-6">
                <q-input
                  v-model="editForm.anio_inicial"
                  label="Año Inicial"
                  type="number"
                  filled
                />
              </div>
              <div class="col-12">
                <q-input
                  v-model="editForm.direccion"
                  label="Dirección"
                  filled
                  @input="editForm.direccion = $event.toUpperCase()"
                />
              </div>
              <div class="col-12">
                <q-input
                  v-model="editForm.telefono"
                  label="Teléfono"
                  filled
                  @input="editForm.telefono = $event.toUpperCase()"
                />
              </div>
              <div class="col-12">
                <q-input
                  v-model="editForm.resumen"
                  label="Resumen"
                  type="textarea"
                  filled
                  @input="editForm.resumen = $event.toUpperCase()"
                />
              </div>
              <!-- ///////////////////////////////// -->
              <div class="col-12">
                <q-file
                  v-model="imageFile"
                  label="Subir portada (solo JPG)"
                  accept=".jpg,.jpeg"
                  max-files="1"
                  outlined
                  dense
                  @update:model-value="handleImageUpload"
                >
                  <template v-slot:prepend>
                    <q-icon name="attach_file" />
                  </template>
                </q-file>

                <!-- Previsualización de la imagen -->
                <q-img
                  v-if="imagePreview"
                  :src="imagePreview"
                  style="max-width: 200px; max-height: 200px; margin-top: 10px"
                  class="q-mt-sm"
                />

              </div>
              <!-- ///////////////////////////////// -->
            </div>

            <div class="row justify-end">
              <q-btn
                icon="cancel"
                color="negative"
                type="reset"
                @click="closeEditModal"
              />
              <q-btn
                icon="save"
                color="primary"
                type="submit"
                class="q-ml-sm"
              />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from "vue";
import { LocalStorage, Notify } from "quasar";
import axios from "axios";
const imageFile = ref(null);
const imagePreview = ref(null);
const uploadingImage = ref(false);
const imageBaseUrl = import.meta.env.VITE_IMAGE_BASE_URL;
// Definición de columnas para la tabla
const columns = [
  { name: "actions", label: "Acciones", align: "left" },
  {
    name: "id",
    label: "ID",
    field: "id",
    sortable: true,
    filterable: true,
    align: "left",
    type: "text",
  },
  {
    name: "revista",
    label: "Revista",
    field: "revista",
    sortable: true,
    filterable: true,
    align: "left",
    type: "text",
  },
  {
    name: "area_conocimiento",
    label: "Área de Conocimiento",
    field: "area_conocimiento",
    sortable: true,
    filterable: true,
    align: "left",
    type: "select",
  },
  {
    name: "idioma",
    label: "Idioma",
    field: "idioma",
    sortable: true,
    filterable: true,
    align: "left",
    type: "select",
  },
  {
    name: "editorial",
    label: "Editorial",
    field: "editorial",
    sortable: true,
    filterable: true,
    align: "left",
    type: "select",
  },
  {
    name: "estado",
    label: "Estado",
    field: "estado",
    sortable: true,
    filterable: true,
    align: "left",
    type: "select",
  },
  {
    name: "indice",
    label: "Índice",
    field: "indice",
    sortable: true,
    filterable: true,
    align: "left",
    type: "select",
  },
  {
    name: "deposito_legal_impreso",
    label: "Depósito Legal Impreso",
    field: "deposito_legal_impreso",
    sortable: true,
    filterable: true,
    align: "left",
    type: "text",
  },
  {
    name: "deposito_legal_digital",
    label: "Depósito Legal Digital",
    field: "deposito_legal_digital",
    sortable: true,
    filterable: true,
    align: "left",
    type: "text",
  },
  {
    name: "issn_impreso",
    label: "ISSN Impreso",
    field: "issn_impreso",
    sortable: true,
    filterable: true,
    align: "left",
    type: "text",
  },
  {
    name: "issn_digital",
    label: "ISSN Digital",
    field: "issn_digital",
    sortable: true,
    filterable: true,
    align: "left",
    type: "text",
  },
  {
    name: "anio_inicial",
    label: "Año Inicial",
    field: "anio_inicial",
    sortable: true,
    filterable: true,
    align: "left",
    type: "text",
  },
];

// URLs de los endpoints
const apiURL = import.meta.env.VITE_API_URL;
const areasURL = import.meta.env.VITE_AREASR_BASE_URL;
const idiomasURL = import.meta.env.VITE_IDIOMASR_BASE_URL;
const editorialesURL = import.meta.env.VITE_EDITORIALR_BASE_URL;
const estadosURL = import.meta.env.VITE_ESTADOR_BASE_URL;
const indicesURL = import.meta.env.VITE_INDICESR_BASE_URL;
const periodicidadURL = import.meta.env.VITE_PERIODICIDADR_BASE_URL;
const formatosURL = import.meta.env.VITE_FORMATOR_BASE_URL;
const revistaDetailURL = import.meta.env.VITE_REVISTA_URL;
const updateURL = import.meta.env.VITE_RV_UPDATE_URL;
const insertURL = import.meta.env.VITE_RV_INSERT_URL;
const insertWithUploadURL = import.meta.env.VITE_RV_INSERT_WITH_UPLOAD_URL;

const areasLsURL = import.meta.env.VITE_LS_AREAS_URL;
const idiomasLsURL = import.meta.env.VITE_LS_IDIOMAS_URL;
const editorialesLsURL = import.meta.env.VITE_LS_EDITORIALES_URL;
const estadosLsURL = import.meta.env.VITE_LS_ESTADOS_URL;
const indicesLsURL = import.meta.env.VITE_LS_INDICES_URL;
const periodicidadLsURL = import.meta.env.VITE_LS_PERIODICIDAD_URL;
const formatosLsURL = import.meta.env.VITE_LS_FORMATOS_URL;

// Estado de la aplicación
const journals = ref([]);
const loading = ref(true);
const pagination = ref({
  sortBy: "desc",
  descending: false,
  page: 1,
  rowsPerPage: 10,
});

// Búsqueda general
const searchQuery = ref("");

// Filtros para las columnas
const filters = ref({
  area_conocimiento: null,
  idioma: null,
  editorial: null,
  estado: null,
  indice: null,
});

// Opciones para los select
const options = ref({
  area_conocimiento: [],
  idioma: [],
  editorial: [],
  estado: [],
  indice: [],
});
const optionsu = ref({
  area_conocimiento: [],
  idioma: [],
  editorial: [],
  estado: [],
  indice: [],
  periodicidad: [],
  formato: [],
});

// Opciones adicionales
const periodicidadOptions = ref([]);
const formatoOptions = ref([]);

// Estado del modal de edición
const editDialog = ref(false);
const editForm = ref({});

// Función para obtener los datos de las revistas
const fetchJournals = async () => {
  try {
    const response = await axios.get(apiURL);
    journals.value = response.data;
  } catch (error) {
    console.error("Error al obtener las revistas:", error);
  } finally {
    loading.value = false;
  }
};

// Función para obtener las opciones de los filtros
const fetchOptions = async () => {
  try {
    const areasResponse = await axios.get(areasURL);
    options.value.area_conocimiento = areasResponse.data.map(
      (item) => item.area_conocimiento
    );
    const areasResponseU = await axios.get(areasLsURL);
    optionsu.value.area_conocimiento = areasResponseU.data.map((item) => ({
      label: item.area_conocimiento,
      value: item.id_area_conocimiento,
    }));

    // Obtener idiomas
    const idiomasResponse = await axios.get(idiomasURL);
    options.value.idioma = idiomasResponse.data.map((item) => item.idioma);
    const idiomasResponseU = await axios.get(idiomasLsURL);
    optionsu.value.idioma = idiomasResponseU.data.map((item) => ({
      label: item.idioma,
      value: item.id_idioma,
    }));
    // Obtener editoriales
    const editorialesResponse = await axios.get(editorialesURL);
    options.value.editorial = editorialesResponse.data.map(
      (item) => item.editorial
    );
    const editorialesResponseU = await axios.get(editorialesLsURL);
    optionsu.value.editorial = editorialesResponseU.data.map((item) => ({
      label: item.editorial,
      value: item.id_editorial,
    }));

    // Obtener estados
    const estadosResponse = await axios.get(estadosURL);
    options.value.estado = estadosResponse.data.map((item) => item.estado);
    const estadosResponseU = await axios.get(estadosLsURL);
    optionsu.value.estado = estadosResponseU.data.map((item) => ({
      label: item.estado,
      value: item.id,
    }));

    // Obtener índices
    const indicesResponse = await axios.get(indicesURL);
    options.value.indice = indicesResponse.data.map((item) => item.indice);
    const indicesResponseU = await axios.get(indicesLsURL);
    optionsu.value.indice = indicesResponseU.data.map((item) => ({
      label: item.indice,
      value: item.id_indice,
    }));

    // Obtener periodicidad
    const periodicidadResponse = await axios.get(periodicidadURL);
    periodicidadOptions.value = periodicidadResponse.data.map(
      (item) => item.periodicidad
    );
    const periodicidadResponseU = await axios.get(periodicidadLsURL);
    optionsu.value.periodicidad = periodicidadResponseU.data.map((item) => ({
      label: item.periodicidad,
      value: item.id_periodicidad,
    }));

    // Obtener formatos
    const formatoResponse = await axios.get(formatosURL);
    formatoOptions.value = formatoResponse.data.map((item) => item.formato);
    const formatoResponseU = await axios.get(formatosLsURL);
    optionsu.value.formato = formatoResponseU.data.map((item) => ({
      label: item.formato,
      value: item.id_formato,
    }));
  } catch (error) {
    console.error("Error al obtener las opciones de los filtros:", error);
  }
};

// Actualizar los filtros
const updateFilter = (key, value) => {
  filters.value[key] = value;
};

// Borrar un filtro específico
const clearFilter = (filterName) => {
  filters.value[filterName] = null;
};

// Borrar todos los filtros
const clearAllFilters = () => {
  for (const filter in filters.value) {
    filters.value[filter] = null;
  }
  searchQuery.value = "";
};

// Borrar la búsqueda general
const clearSearch = () => {
  searchQuery.value = "";
};

// Obtener las opciones para un filtro select
const getOptions = (filterName) => {
  return options.value[filterName] || [];
};

// Calcular la lista de revistas filtradas
const filteredJournals = computed(() => {
  // Primero filtrar por búsqueda general
  const searchValue = searchQuery.value.toLowerCase();
  let searchedJournals = journals.value.filter((journal) => {
    // Buscar en todos los campos de las columnas filtrables
    return columns
      .filter((col) => col.filterable)
      .some((col) => {
        const journalValue =
          journal[col.field]?.toString()?.toLowerCase() || "";
        return journalValue.includes(searchValue);
      });
  });

  // Luego aplicar los filtros por columna
  return searchedJournals.filter((journal) => {
    return columns
      .filter((col) => col.filterable)
      .every((col) => {
        // Para filtros de tipo select
        if (
          col.type === "select" &&
          filters.value[col.name] &&
          filters.value[col.name].length > 0
        ) {
          return filters.value[col.name].includes(journal[col.field]);
        }

        // Para otros tipos de filtros
        const filterValue = filters.value[col.name]?.toLowerCase() || "";
        const journalValue =
          journal[col.field]?.toString()?.toLowerCase() || "";
        return journalValue.includes(filterValue);
      });
  });
});
const isEditing = ref(false);
// Función para abrir el modal de creación!
const openNewModal = () => {
  editForm.value = {
    // Inicializa todos los campos necesarios
    id: null,
    revista: "",
    area_conocimiento: null,
    indice: null,
    idioma: null,
    correo_revista: "",
    editorial: null,
    periodicidad: null,
    formato: null,
    estado: null,
    ciudad: "",
    nombres_editor: "",
    apellidos_editor: "",
    correo_editor: "",
    deposito_legal_impreso: "",
    deposito_legal_digital: "",
    issn_impreso: "",
    issn_digital: "",
    url: "",
    anio_inicial: "",
    direccion: "",
    telefono: "",
    resumen: "",
    portada: null,
  };
  imagePreview.value = null;
  imageFile.value = null;
  isEditing.value = false;
  editDialog.value = true;
};
////////////Upload portada/////////////
const handleImageUpload = (file) => {
  if (file) {
    // Verificar que sea JPG
    if (!["image/jpeg", "image/jpg"].includes(file.type)) {
      Notify.create({
        type: "negative",
        message: "Solo se permiten archivos JPG",
      });
      imageFile.value = null;
      return;
    }

    // Crear previsualización
    const reader = new FileReader();
    reader.onload = (e) => {
      imagePreview.value = e.target.result;
    };
    reader.readAsDataURL(file);
  } else {
    imagePreview.value = null;
  }
};

// Función para abrir el modal de edición
const openEditModal = async (journal) => {
  try {
    const response = await axios.get(`${revistaDetailURL}${journal.id}`);
    // Asignar los valores del backend y mapear los selects
    const data = response.data;
    editForm.value = {
      ...data,
      area_conocimiento: optionsu.value.area_conocimiento.find(opt => opt.value === data.area_conocimiento_id) || null,
      indice: optionsu.value.indice.find(opt => opt.value === data.indice_id) || null,
      idioma: optionsu.value.idioma.find(opt => opt.value === data.idioma_id) || null,
      editorial: optionsu.value.editorial.find(opt => opt.value === data.editorial_id) || null,
      periodicidad: optionsu.value.periodicidad.find(opt => opt.value === data.periodicidad_id) || null,
      formato: optionsu.value.formato.find(opt => opt.value === data.formato_id) || null,
      estado: optionsu.value.estado.find(opt => opt.value === data.estado_id) || null,
    };

    // Mostrar la imagen de portada usando VITE_IMAGE_BASE_URL y el nombre de portada
    if (editForm.value.portada) {
      imagePreview.value = `${import.meta.env.VITE_IMAGE_BASE_URL}${editForm.value.portada}?t=${Date.now()}`;
    } else {
      imagePreview.value = null;
    }

    editDialog.value = true;
    isEditing.value = true;
  } catch (error) {
    console.error("Error al obtener los datos de la revista:", error);
  }
};

// Función para cerrar el modal de edición
const closeEditModal = () => {
  editDialog.value = false;
};

// Función para guardar los cambios (Refactorizada)
const saveChanges = async () => {
  // 1. Validaciones
  if (!editForm.value.revista || !editForm.value.idioma) {
    Notify.create({ type: "negative", message: "Revista e Idioma son requeridos" });
    return;
  }

  // 2. Construir objeto de datos para PATCH (sin portadaFile)
  const patchData = {};
  const setIfDefined = (key, value) => {
    if (value !== null && value !== undefined) {
      patchData[key] = value;
    }
  };
  setIfDefined('area_conocimiento_id', editForm.value.area_conocimiento?.value);
  setIfDefined('indice_id', editForm.value.indice?.value);
  setIfDefined('idioma_id', editForm.value.idioma?.value);
  setIfDefined('revista', editForm.value.revista);
  setIfDefined('correo_revista', editForm.value.correo_revista);
  setIfDefined('editorial_id', editForm.value.editorial?.value);
  setIfDefined('periodicidad_id', editForm.value.periodicidad?.value);
  setIfDefined('formato_id', editForm.value.formato?.value);
  setIfDefined('estado_id', editForm.value.estado?.value);
  setIfDefined('nombres_editor', editForm.value.nombres_editor);
  setIfDefined('apellidos_editor', editForm.value.apellidos_editor);
  setIfDefined('correo_editor', editForm.value.correo_editor);
  setIfDefined('deposito_legal_impreso', editForm.value.deposito_legal_impreso);
  setIfDefined('deposito_legal_digital', editForm.value.deposito_legal_digital);
  setIfDefined('issn_impreso', editForm.value.issn_impreso);
  setIfDefined('issn_digital', editForm.value.issn_digital);
  setIfDefined('url', editForm.value.url);
  setIfDefined('anio_inicial', editForm.value.anio_inicial);
  setIfDefined('direccion', editForm.value.direccion);
  setIfDefined('telefono', editForm.value.telefono);
  setIfDefined('resumen', editForm.value.resumen);

  try {
    if (isEditing.value) {
      alert("Editando revista");
      // PATCH solo con los datos de la revista
      await axios.patch(`${updateURL}${editForm.value.id}`, patchData);
      Notify.create({ type: "positive", message: "Cambios guardados correctamente." });

      // Si se seleccionó una nueva imagen durante la edición, subirla por separado
      if (imageFile.value && editForm.value.id) {
        const imageFormData = new FormData();
        const file = Array.isArray(imageFile.value) ? imageFile.value[0] : imageFile.value;
        imageFormData.append('portadaFile', file);
        await axios.post(`${import.meta.env.VITE_RV_UPLOAD_URL}/upload-portada/${editForm.value.id}`, imageFormData);
        Notify.create({ type: "positive", message: "Portada actualizada." });
      }

    } else {
      // Lógica de Creación (POST)
      // Una sola llamada que envía todo
      const formData = new FormData();
      const appendIfDefined = (key, value) => {
        if (value !== null && value !== undefined) {
          formData.append(key, value);
        }
      };
      if (imageFile.value) {
        const file = Array.isArray(imageFile.value) ? imageFile.value[0] : imageFile.value;
        appendIfDefined('portadaFile', file);
      }
      appendIfDefined('area_conocimiento_id', editForm.value.area_conocimiento?.value);
      appendIfDefined('indice_id', editForm.value.indice?.value);
      appendIfDefined('idioma_id', editForm.value.idioma?.value);
      appendIfDefined('revista', editForm.value.revista);
      appendIfDefined('correo_revista', editForm.value.correo_revista);
      appendIfDefined('editorial_id', editForm.value.editorial?.value);
      appendIfDefined('periodicidad_id', editForm.value.periodicidad?.value);
      appendIfDefined('formato_id', editForm.value.formato?.value);
      appendIfDefined('estado_id', editForm.value.estado?.value);
      appendIfDefined('nombres_editor', editForm.value.nombres_editor);
      appendIfDefined('apellidos_editor', editForm.value.apellidos_editor);
      appendIfDefined('correo_editor', editForm.value.correo_editor);
      appendIfDefined('deposito_legal_impreso', editForm.value.deposito_legal_impreso);
      appendIfDefined('deposito_legal_digital', editForm.value.deposito_legal_digital);
      appendIfDefined('issn_impreso', editForm.value.issn_impreso);
      appendIfDefined('issn_digital', editForm.value.issn_digital);
      appendIfDefined('url', editForm.value.url);
      appendIfDefined('anio_inicial', editForm.value.anio_inicial);
      appendIfDefined('direccion', editForm.value.direccion);
      appendIfDefined('telefono', editForm.value.telefono);
      appendIfDefined('resumen', editForm.value.resumen);
      await axios.post(insertWithUploadURL, formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });
      Notify.create({ type: "positive", message: "Revista creada correctamente." });
    }

    await fetchJournals();
    closeEditModal();

  } catch (error) {
    console.error("Error al guardar la revista:", error);
    Notify.create({ type: "negative", message: error.response?.data?.error || "Error al guardar la revista" });
  }
};


// Observar cambios en la paginación
watch(pagination, () => {}, { deep: true });

// Obtener los datos al montar el componente
onMounted(async () => {
  if (!LocalStorage.getItem("token")) {
    router.push("/login");
  }
  await fetchOptions();
  fetchJournals();
});
</script>

<style scoped>
.responsive-table {
  max-width: 100%;
  overflow-x: auto;
}

@media (max-width: 768px) {
  .responsive-table {
    overflow-x: scroll;
  }
}
</style>
