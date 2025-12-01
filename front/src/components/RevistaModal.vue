<template>
  <q-dialog :model-value="modelValue" persistent @update:model-value="emit('update:modelValue', $event)">
    <q-card class="q-pa-md" style="width: 700px; max-width: 80vw">
      <q-card-section>
        <div class="text-h6">
          {{ isEditing ? "Editar Revista" : "Nueva Revista" }}
        </div>
      </q-card-section>
      <q-card-section>
        <q-form @submit="onSave" class="q-gutter-md">
          <q-tabs
            v-model="activeTab"
            dense
            align="justify"
            class="q-mb-md bg-grey-2 text-primary"
            indicator-color="primary"
          >
            <q-tab name="revista" label="REVISTA" shrink />
            <q-tab name="editor" label="EDITORIAL" shrink />
          </q-tabs>
          <q-tab-panels v-model="activeTab" animated>
            <q-tab-panel name="revista">
              <div class="row q-col-gutter-md">
                <div class="col-12 col-md-6"><q-input v-model="localForm.id" label="ID" readonly filled /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.revista" label="Revista" filled @keyup="forceInputCase($event, 'revista', 'upper')" class="uppercase-input" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.deposito_legal_impreso" label="Depósito Legal Impreso" filled @keyup="forceInputCase($event, 'deposito_legal_impreso', 'upper')" class="uppercase-input" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.deposito_legal_digital" label="Depósito Legal Digital" filled @input="forceInputCase($event, 'deposito_legal_digital')" class="uppercase-input" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.issn_impreso" label="ISSN Impreso" filled @input="forceInputCase($event, 'issn_impreso')" class="uppercase-input" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.issn_digital" label="ISSN Digital" filled @input="forceInputCase($event, 'issn_digital')" class="uppercase-input" /></div>
                <div class="col-12 col-md-6"><q-select v-model="localForm.area_conocimiento" :options="filteredAreas" label="Área de Conocimiento" filled option-label="label" option-value="value" emit-value map-options use-input input-debounce="300" @filter="filterAreas" /></div>
                <div class="col-12 col-md-6"><q-select v-model="localForm.indice" :options="filteredIndices" label="Índice" filled option-label="label" option-value="value" emit-value map-options use-input input-debounce="300" @filter="filterIndices" /></div>
                <div class="col-12 col-md-6"><q-select v-model="localForm.idioma" :options="filteredIdiomas" label="Idioma" filled option-label="label" option-value="value" emit-value map-options use-input input-debounce="300" @filter="filterIdiomas" /></div>
                <div class="col-12 col-md-6"><q-select v-model="localForm.formato" :options="filteredFormatos" label="Formato" filled option-label="label" option-value="value" emit-value map-options use-input input-debounce="300" @filter="filterFormatos" /></div>
                <div class="col-12 col-md-6"><q-select v-model="localForm.periodicidad" :options="filteredPeriodicidad" label="Periodicidad" filled option-label="label" option-value="value" emit-value map-options use-input input-debounce="300" @filter="filterPeriodicidad" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.anio_inicial" label="Año Inicial" type="number" filled @input="localForm.anio_inicial = $event.toUpperCase()" class="uppercase-input" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.url" label="URL" type="url" filled @keyup="forceInputCase($event, 'url', 'lower')" class="lowercase-input" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.correo_revista" label="Correo Revista" type="email" filled @keyup="forceInputCase($event, 'correo_revista', 'lower')" class="lowercase-input" /></div>
                <div class="col-12"><q-input v-model="localForm.direccion" label="Dirección" filled @input="localForm.direccion = $event.toUpperCase()" class="uppercase-input" /></div>
              </div>
            </q-tab-panel>
            <q-tab-panel name="editor">
              <div class="row q-col-gutter-md">
                <div class="col-12 col-md-6"><q-select v-model="localForm.editorial" :options="filteredEditoriales" label="Editorial" filled option-label="label" option-value="value" emit-value map-options use-input input-debounce="300" @filter="filterEditoriales" /></div>
                <div class="col-12 col-md-6"><q-select v-model="localForm.estado" :options="filteredEstados" label="Estado" filled option-label="label" option-value="value" emit-value map-options use-input input-debounce="300" @filter="filterEstados" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.nombres_editor" label="Nombres Editor" filled @input="localForm.nombres_editor = $event.toUpperCase()" class="uppercase-input" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.apellidos_editor" label="Apellidos Editor" filled @input="localForm.apellidos_editor = $event.toUpperCase()" class="uppercase-input" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.correo_editor" label="Correo Editor" type="email" filled @input="localForm.correo_editor = $event.toLowerCase()" class="lowercase-input" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.telefono" label="Teléfono Editor" filled @input="localForm.telefono = $event.toUpperCase()" class="uppercase-input" /></div>
              </div>
              <div class="row justify-end q-mt-md">
                <q-btn icon="cancel" color="negative" type="reset" @click="onClose" />
                <q-btn icon="save" color="primary" type="submit" class="q-ml-sm" />
              </div>
            </q-tab-panel>
          </q-tab-panels>
          <!-- Fuera del tab panel -->
          <div class="row q-col-gutter-md q-mt-md">
            <div class="col-12">
              <q-input v-model="localForm.resumen" label="Resumen" type="textarea" filled @input="localForm.resumen = $event.toUpperCase()" class="uppercase-input" />
            </div>
          </div>
          <div class="row q-col-gutter-md q-mt-md">
            <div class="col-12">
              <q-file v-model="imageFile" label="Subir portada (solo JPG)" accept=".jpg,.jpeg" max-files="1" outlined dense @update:model-value="handleImageUpload">
                <template v-slot:prepend>
                  <q-icon name="attach_file" />
                </template>
              </q-file>
              <q-img v-if="imagePreview" :src="imagePreview" style="max-width: 200px; max-height: 200px; margin-top: 10px" class="q-mt-sm" />
            </div>
          </div>
          <!-- Botones de acción movidos al tab EDITORIAL -->
        </q-form>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script setup>
import { ref, watch, computed } from 'vue';
const activeTab = ref('revista');
const props = defineProps({
  modelValue: Boolean,
  editForm: Object,
  isEditing: Boolean,
  optionsu: Object,
  imagePreview: String,
  imageFile: [File, Array, null],
});
const emit = defineEmits(['update:modelValue', 'save', 'close', 'update:imageFile', 'update:imagePreview']);
const localForm = ref({ ...props.editForm });
watch(() => props.editForm, (val) => {
  localForm.value = { ...val };
}, { deep: true, immediate: true });
const imageFile = ref(props.imageFile || null);
const imagePreview = ref(props.imagePreview || null);
watch(() => props.imageFile, (val) => { imageFile.value = val; });
watch(() => props.imagePreview, (val) => { imagePreview.value = val; });

// Variables reactivas para opciones filtradas
const filteredAreas = ref(props.optionsu?.area_conocimiento || []);
const filteredIndices = ref(props.optionsu?.indice || []);
const filteredIdiomas = ref(props.optionsu?.idioma || []);
const filteredFormatos = ref(props.optionsu?.formato || []);
const filteredPeriodicidad = ref(props.optionsu?.periodicidad || []);
const filteredEditoriales = ref(props.optionsu?.editorial || []);
const filteredEstados = ref(props.optionsu?.estado || []);

// Watch para actualizar las opciones filtradas cuando cambian las props
watch(() => props.optionsu, (val) => {
  if (val) {
    filteredAreas.value = val.area_conocimiento || [];
    filteredIndices.value = val.indice || [];
    filteredIdiomas.value = val.idioma || [];
    filteredFormatos.value = val.formato || [];
    filteredPeriodicidad.value = val.periodicidad || [];
    filteredEditoriales.value = val.editorial || [];
    filteredEstados.value = val.estado || [];
  }
}, { deep: true, immediate: true });

// Función genérica de filtrado
const filterFn = (val, update, fullOptions, filteredRef) => {
  update(() => {
    if (val === '') {
      filteredRef.value = fullOptions || [];
    } else {
      const needle = val.toLowerCase();
      filteredRef.value = (fullOptions || []).filter(
        item => item.label.toLowerCase().indexOf(needle) > -1
      );
    }
  });
};

// Funciones de filtrado para cada select
const filterAreas = (val, update) => filterFn(val, update, props.optionsu?.area_conocimiento, filteredAreas);
const filterIndices = (val, update) => filterFn(val, update, props.optionsu?.indice, filteredIndices);
const filterIdiomas = (val, update) => filterFn(val, update, props.optionsu?.idioma, filteredIdiomas);
const filterFormatos = (val, update) => filterFn(val, update, props.optionsu?.formato, filteredFormatos);
const filterPeriodicidad = (val, update) => filterFn(val, update, props.optionsu?.periodicidad, filteredPeriodicidad);
const filterEditoriales = (val, update) => filterFn(val, update, props.optionsu?.editorial, filteredEditoriales);
const filterEstados = (val, update) => filterFn(val, update, props.optionsu?.estado, filteredEstados);

const handleImageUpload = (file) => {
  if (file) {
    if (!['image/jpeg', 'image/jpg'].includes(file.type)) {
      imageFile.value = null;
      emit('update:imageFile', null);
      emit('update:imagePreview', null);
      return;
    }
    const reader = new FileReader();
    reader.onload = (e) => {
      imagePreview.value = e.target.result;
      emit('update:imagePreview', e.target.result);
    };
    reader.readAsDataURL(file);
    imageFile.value = file;
    emit('update:imageFile', file);
  } else {
    imagePreview.value = null;
    imageFile.value = null;
    emit('update:imageFile', null);
    emit('update:imagePreview', null);
  }
};
const onSave = (e) => {
  e.preventDefault();
  console.log('🔍 [RevistaModal] Datos en localForm antes de emitir:');
  console.log('  - localForm.area_conocimiento:', localForm.value.area_conocimiento);
  console.log('  - localForm.idioma:', localForm.value.idioma);
  console.log('  - localForm completo:', localForm.value);
  emit('save', localForm.value, imageFile.value);
};
const onClose = () => {
  emit('close');
  emit('update:modelValue', false);
};
function forceInputCase(event, modelKey, type = 'upper') {
  const el = event.target;
  if (!el) return;
  if (type === 'upper') {
    el.value = el.value.toUpperCase();
    localForm.value[modelKey] = el.value;
  } else {
    el.value = el.value.toLowerCase();
    localForm.value[modelKey] = el.value;
  }
}
</script>

<style scoped>
/* Visual para mayúsculas/minúsculas */
.q-mt-sm {
  margin-top: 10px;
}
.uppercase-input input,
.uppercase-input textarea {
  text-transform: uppercase;
}
.lowercase-input input,
.lowercase-input textarea {
  text-transform: lowercase;
}
</style>
