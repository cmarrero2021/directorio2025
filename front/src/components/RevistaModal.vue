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
                <div class="col-12 col-md-6"><q-input v-model="localForm.revista" label="Revista" filled @input="localForm.revista = $event.toUpperCase()" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.deposito_legal_impreso" label="Depósito Legal Impreso" filled @input="localForm.deposito_legal_impreso = $event.toUpperCase()" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.deposito_legal_digital" label="Depósito Legal Digital" filled @input="localForm.deposito_legal_digital = $event.toUpperCase()" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.issn_impreso" label="ISSN Impreso" filled @input="localForm.issn_impreso = $event.toUpperCase()" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.issn_digital" label="ISSN Digital" filled @input="localForm.issn_digital = $event.toUpperCase()" /></div>
                <div class="col-12 col-md-6"><q-select v-model="localForm.area_conocimiento" :options="optionsu.area_conocimiento" label="Área de Conocimiento" filled option-label="label" option-value="value" /></div>
                <div class="col-12 col-md-6"><q-select v-model="localForm.indice" :options="optionsu.indice" label="Índice" filled option-label="label" option-value="value" /></div>
                <div class="col-12 col-md-6"><q-select v-model="localForm.idioma" :options="optionsu.idioma" label="Idioma" filled option-label="label" option-value="value" /></div>
                <div class="col-12 col-md-6"><q-select v-model="localForm.formato" :options="optionsu.formato" label="Formato" filled option-label="label" option-value="value" /></div>
                <div class="col-12 col-md-6"><q-select v-model="localForm.periodicidad" :options="optionsu.periodicidad" label="Periodicidad" filled option-label="label" option-value="value" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.anio_inicial" label="Año Inicial" type="number" filled /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.url" label="URL" type="url" filled /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.correo_revista" label="Correo Revista" type="email" filled /></div>
              </div>
            </q-tab-panel>
            <q-tab-panel name="editor">
              <div class="row q-col-gutter-md">
                <div class="col-12 col-md-6"><q-select v-model="localForm.editorial" :options="optionsu.editorial" label="Editorial" filled option-label="label" option-value="value" /></div>
                <div class="col-12 col-md-6"><q-select v-model="localForm.estado" :options="optionsu.estado" label="Estado" filled option-label="label" option-value="value" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.nombres_editor" label="Nombres Editor" filled @input="localForm.nombres_editor = $event.toUpperCase()" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.apellidos_editor" label="Apellidos Editor" filled @input="localForm.apellidos_editor = $event.toUpperCase()" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.correo_editor" label="Correo Editor" type="email" filled /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.telefono" label="Teléfono Editor" filled @input="localForm.telefono = $event.toUpperCase()" /></div>
                <div class="col-12 col-md-6"><q-input v-model="localForm.direccion" label="Dirección" filled @input="localForm.direccion = $event.toUpperCase()" /></div>
              </div>
            </q-tab-panel>
          </q-tab-panels>
          <!-- Fuera del tab panel -->
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
          <div class="row justify-end">
            <q-btn icon="cancel" color="negative" type="reset" @click="onClose" />
            <q-btn icon="save" color="primary" type="submit" class="q-ml-sm" />
          </div>
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
});
const imageFile = ref(props.imageFile || null);
const imagePreview = ref(props.imagePreview || null);
watch(() => props.imageFile, (val) => { imageFile.value = val; });
watch(() => props.imagePreview, (val) => { imagePreview.value = val; });
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
  emit('save', localForm.value, imageFile.value);
};
const onClose = () => {
  emit('close');
  emit('update:modelValue', false);
};
</script>

<style scoped>
.q-mt-sm {
  margin-top: 10px;
}
</style>
