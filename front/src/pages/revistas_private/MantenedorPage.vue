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

                <!-- Botón para subir la imagen -->
                <!-- <q-btn
                  v-if="imageFile"
                  label="Subir Portada"
                  color="primary"
                  @click="uploadImage"
                  class="q-mt-sm"
                  :loading="uploadingImage"
                /> -->
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
const imageBaseUrl =
  import.meta.env.VITE_IMAGE_BASE_URL ||
  "http://poi-r.vps.co.ve/apiq/public/portadas/";
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
const apiURL = import.meta.env.VITE_API_URL || "http://poi-r.vps.co.ve:3000/";
const areasURL =
  import.meta.env.VITE_AREASR_BASE_URL ||
  "http://poi-r.vps.co.ve:3000/areas_revistas";
const idiomasURL =
  import.meta.env.VITE_IDIOMASR_BASE_URL ||
  "http://poi-r.vps.co.ve:3000/idiomas_revistas";
const editorialesURL =
  import.meta.env.VITE_EDITORIALR_BASE_URL ||
  "http://poi-r.vps.co.ve:3000/editorial_revistas";
const estadosURL =
  import.meta.env.VITE_ESTADOR_BASE_URL ||
  "http://poi-r.vps.co.ve:3000/estado_revistas";
const indicesURL =
  import.meta.env.VITE_INDICESR_BASE_URL ||
  "http://poi-r.vps.co.ve:3000/indices_revistas";
const periodicidadURL =
  import.meta.env.VITE_PERIODICIDADR_BASE_URL ||
  "http://poi-r.vps.co.ve:3000/periodicidad_revistas";
const formatosURL =
  import.meta.env.VITE_FORMATOR_BASE_URL ||
  "http://poi-r.vps.co.ve:3000/formato_revistas";
const revistaDetailURL =
  import.meta.env.VITE_REVISTA_URL || "http://poi-r.vps.co.ve:3000/revistas/";
const updateURL =
  import.meta.env.VITE_RV_UPDATE_URL || "http://poi-r.vps.co.ve:3001/revistas/";
const insertURL =
  import.meta.env.VITE_RV_INSERT_URL ||
  "http://poi-r.vps.co.ve:3001/auth/revista";

const areasLsURL =
  import.meta.env.VITE_LS_AREAS_URL ||
  "http://poi-r.vps.co.ve:3000/lista_areas";
const idiomasLsURL =
  import.meta.env.VITE_LS_IDIOMAS_URL ||
  "http://poi-r.vps.co.ve:3000/lista_idiomas";
const editorialesLsURL =
  import.meta.env.VITE_LS_EDITORIAL_URL ||
  "http://poi-r.vps.co.ve:3000/lista_editoriales";
const estadosLsURL =
  import.meta.env.VITE_LS_ESTADOS_URL ||
  "http://poi-r.vps.co.ve:3000/lista_estados";
const indicesLsURL =
  import.meta.env.VITE_LS_INDICES_URL ||
  "http://poi-r.vps.co.ve:3000/lista_indices";
const periodicidadLsURL =
  import.meta.env.VITE_LS_PERIODICIDAD_URL ||
  "http://poi-r.vps.co.ve:3000/lista_indices";
const formatosLsURL =
  import.meta.env.VITE_LS_FORMATOS_URL ||
  "http://poi-r.vps.co.ve:3000/lista_indices";

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
      label: item.idioma || item.nombre || item.label || String(item.id_idioma || item.id || item.value),
      value: item.id_idioma ?? item.id ?? item.value ?? item.idioma ?? item.nombre ?? item.label,
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
      label: item.indice || item.nombre || item.label || String(item.id_indice || item.id || item.value),
      value: item.id_indice ?? item.id ?? item.value ?? item.indice ?? item.nombre ?? item.label,
    }));

    // Obtener periodicidad
    const periodicidadResponse = await axios.get(periodicidadURL);
    periodicidadOptions.value = periodicidadResponse.data.map(
      (item) => item.periodicidad
    );
    const periodicidadResponseU = await axios.get(periodicidadLsURL);
    optionsu.value.periodicidad = periodicidadResponseU.data.map((item) => ({
      label: item.periodicidad || item.nombre || item.label || String(item.id_periodicidad || item.id || item.value),
      value: item.id_periodicidad ?? item.id ?? item.value ?? item.periodicidad ?? item.nombre ?? item.label,
    }));

    // Obtener formatos
    const formatoResponse = await axios.get(formatosURL);
    formatoOptions.value = formatoResponse.data.map((item) => item.formato);
    const formatoResponseU = await axios.get(formatosLsURL);
    optionsu.value.formato = formatoResponseU.data.map((item) => ({
      label: item.formato || item.nombre || item.label || String(item.id_formato || item.id || item.value),
      value: item.id_formato ?? item.id ?? item.value ?? item.formato ?? item.nombre ?? item.label,
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

const uploadImage = async () => {
  if (!imageFile.value) return;

  uploadingImage.value = true;

  try {
    const formData = new FormData();
    // Usamos el archivo original sin renombrar (el endpoint lo hará)
    const f = Array.isArray(imageFile.value) ? imageFile.value[0] : imageFile.value;
    formData.append("archivo", f);

    // Usamos la URL del .env y el endpoint de prueba
    console.log(`${import.meta.env.VITE_RV_UPLOAD_URL}/test-upload`);
    const response = await axios.post(
      `${import.meta.env.VITE_RV_UPLOAD_URL}/test-upload`,
      formData
    );

    Notify.create({
      type: "positive",
      message: "Portada subida correctamente",
    });

    // Actualizar la vista previa con la nueva URL
    // El endpoint devuelve el nombre del archivo en response.data.filename
    const timestamp = Date.now();
    imagePreview.value = `${import.meta.env.VITE_IMAGE_BASE_URL}${
      response.data.filename
    }?t=${timestamp}`;
    editForm.value.portada = imagePreview.value;
    return response;
  } catch (error) {
    console.error("Error al subir la imagen:", error);

    let errorMessage = "Error al subir la portada";
    if (error.response) {
      // Manejo de errores específicos del servidor
      if (error.response.data.error) {
        errorMessage = error.response.data.error;
      } else if (error.response.status === 400) {
        errorMessage = "Archivo no válido (solo JPG/PNG, máximo 5MB)";
      }
    }

    Notify.create({
      type: "negative",
      message: errorMessage,
    });
  } finally {
    uploadingImage.value = false;
  }
};
///////////////////////////////////////
// Función para abrir el modal de edición
///////////////////////
const openEditModal = async (journal) => {
  try {
    const response = await axios.get(`${revistaDetailURL}${journal.id}`);
    editForm.value = { ...response.data };

    // Cargar imagen existente si existe
    if (editForm.value.id) {
      imagePreview.value = `${imageBaseUrl}revistas/${
        editForm.value.id
      }/portada.jpg?t=${Date.now()}`;
    }

    editDialog.value = true;
    isEditing.value = true;
  } catch (error) {
    console.error("Error al obtener los datos de la revista:", error);
  }
};
////////////////////////
// Función para cerrar el modal de edición
const closeEditModal = () => {
  editDialog.value = false;
};
// Función para guardar los cambios
const saveChanges = async () => {
  // Validar campos requeridos
  if (!editForm.value.revista) {
    Notify.create({
      type: "negative",
      message: "El nombre de la revista es requerido",
    });
    return;
  }

  if (!editForm.value.idioma) {
    Notify.create({
      type: "negative",
      message: "El idioma es requerido",
    });
    return;
  }

  // Extraer IDs de los objetos seleccionados, manejando casos donde el valor puede ser null
  const areaConocimientoId = editForm.value.area_conocimiento?.value || null;
  const indiceId = editForm.value.indice?.value || null;
  const idiomaId = editForm.value.idioma?.value || null;
  const editorialId = editForm.value.editorial?.value || null;
  const periodicidadId = editForm.value.periodicidad?.value || null;
  const formatoId = editForm.value.formato?.value || null;
  const estadoId = editForm.value.estado?.value || null;

  const revistaData = {
    area_conocimiento_id: areaConocimientoId,
    indice_id: indiceId,
    idioma_id: idiomaId,
    revista: editForm.value.revista,
    correo_revista: editForm.value.correo_revista,
    editorial_id: editorialId,
    periodicidad_id: periodicidadId,
    formato_id: formatoId,
    estado_id: estadoId,
    nombres_editor: editForm.value.nombres_editor,
    apellidos_editor: editForm.value.apellidos_editor,
    correo_editor: editForm.value.correo_editor,
    deposito_legal_impreso: editForm.value.deposito_legal_impreso,
    deposito_legal_digital: editForm.value.deposito_legal_digital,
    issn_impreso: editForm.value.issn_impreso,
    issn_digital: editForm.value.issn_digital,
    url: editForm.value.url,
    anio_inicial: editForm.value.anio_inicial,
    direccion: editForm.value.direccion,
    telefono: editForm.value.telefono,
    resumen: editForm.value.resumen,
    portada: null, // Se asigna después del upload
  };

  // Debug: mostrar los valores que se van a enviar
  console.log('Datos a enviar:', revistaData);
  if (isEditing.value) {
    await axios.patch(`${updateURL}${editForm.value.id}`, revistaData);
    Notify.create({
      type: "positive",
      message: "Los cambios se han guardado correctamente.",
    });
    // Subir la portada si hay imagen seleccionada
    if (imageFile.value && editForm.value.id) {
      const uploadResp = await uploadImage();
      // Actualizar la revista con el nombre de la portada subida
      if (uploadResp && uploadResp.data && uploadResp.data.filename) {
        await axios.patch(`${updateURL}${editForm.value.id}`, { portada: uploadResp.data.filename });
      }
    }
  } else {
    // Subir portada primero (si existe)
    let uploadedFilename = null;
    if (imageFile.value) {
      const uploadResp = await uploadImage();
      if (uploadResp && uploadResp.data && uploadResp.data.filename) {
        uploadedFilename = uploadResp.data.filename; // Se guarda el archivo con su nombre original
      }
    }

    // Insertar la revista estableciendo portada a la cadena PORTADA.JPG
    const revistaDataToInsert = {
      ...revistaData,
      portada: 'PORTADA.JPG',
    };

    const response = await axios.post(insertURL, revistaDataToInsert);
    const newId = response.data?.revista?.id || response.data?.id;
    if (newId) {
      editForm.value.id = newId;
    }

    Notify.create({
      type: "positive",
      message: "La revista se ha creado correctamente.",
    });
  }

  // Actualizar la lista de revistas
  await fetchJournals();
  closeEditModal();
};

////////////////
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
