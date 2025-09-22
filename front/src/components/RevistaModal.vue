<template>
  <q-dialog :model-value="modelValue" persistent @update:model-value="emit('update:modelValue', $event)">
    <q-card style="width: 700px; max-width: 80vw">
      <q-card-section>
        <div class="text-h6">
          {{ isEditing ? "Editar Revista" : "Nueva Revista" }}
        </div>
      </q-card-section>
      <q-card-section>
        <q-form @submit="onSave" class="q-gutter-md">
          <div class="row q-col-gutter-md">
            <!-- Campos del formulario -->
            <div class="col-12 col-md-6">
              <q-input v-model="localForm.id" label="ID" readonly filled></q-input>
            </div>
            <div class="col-12 col-md-6">
              <q-input v-model="localForm.revista" label="Revista" filled @input="localForm.revista = $event.toUpperCase()"></q-input>
            </div>
            <div class="col-12 col-md-6">
              <q-select v-model="localForm.area_conocimiento" :options="optionsu.area_conocimiento" label="Área de Conocimiento" filled option-label="label" option-value="value"></q-select>
            </div>
            <div class="col-12 col-md-6">
              <q-select v-model="localForm.indice" :options="optionsu.indice" label="Índice" filled option-label="label" option-value="value"></q-select>
            </div>
            <div class="col-12 col-md-6">
              <q-select v-model="localForm.idioma" :options="optionsu.idioma" label="Idioma" filled option-label="label" option-value="value"></q-select>
            </div>
            <div class="col-12 col-md-6">
              <q-input v-model="localForm.correo_revista" label="Correo de la Revista" type="email" filled></q-input>
            </div>
            <div class="col-12 col-md-6">
              <q-select v-model="localForm.editorial" :options="optionsu.editorial" label="Editorial" filled option-label="label" option-value="value"></q-select>
            </div>
            <div class="col-12 col-md-6">
              <q-select v-model="localForm.periodicidad" :options="optionsu.periodicidad" label="Periodicidad" filled option-label="label" option-value="value"></q-select>
            </div>
            <div class="col-12 col-md-6">
              <q-select v-model="localForm.formato" :options="optionsu.formato" label="Formato" filled option-label="label" option-value="value"></q-select>
            </div>
            <div class="col-12 col-md-6">
              <q-select v-model="localForm.estado" :options="optionsu.estado" label="Estado" filled option-label="label" option-value="value"></q-select>
            </div>
            <div class="col-12 col-md-6">
              <q-input v-model="localForm.ciudad" label="Ciudad" filled @input="localForm.ciudad = $event.toUpperCase()"></q-input>
            </div>
            <div class="col-12 col-md-6">
              <q-input v-model="localForm.nombres_editor" label="Nombres del Editor" filled @input="localForm.nombres_editor = $event.toUpperCase()"></q-input>
            </div>
            <div class="col-12 col-md-6">
              <q-input v-model="localForm.apellidos_editor" label="Apellidos del Editor" filled @input="localForm.apellidos_editor = $event.toUpperCase()"></q-input>
            </div>
            <div class="col-12 col-md-6">
              <q-input v-model="localForm.correo_editor" label="Correo del Editor" type="email" filled></q-input>
            </div>
            <div class="col-12 col-md-6">
              <q-input v-model="localForm.deposito_legal_impreso" label="Depósito Legal Impreso" filled @input="localForm.deposito_legal_impreso = $event.toUpperCase()"></q-input>
            </div>
            <div class="col-12 col-md-6">
              <q-input v-model="localForm.deposito_legal_digital" label="Depósito Legal Digital" filled @input="localForm.deposito_legal_digital = $event.toUpperCase()"></q-input>
            </div>
            <div class="col-12 col-md-6">
              <q-input v-model="localForm.issn_impreso" label="ISSN Impreso" filled @input="localForm.issn_impreso = $event.toUpperCase()"></q-input>
            </div>
            <div class="col-12 col-md-6">
              <q-input v-model="localForm.issn_digital" label="ISSN Digital" filled @input="localForm.issn_digital = $event.toUpperCase()"></q-input>
            </div>
            <div class="col-12 col-md-6">
              <q-input v-model="localForm.url" label="URL" type="url" filled></q-input>
            </div>
            <div class="col-12 col-md-6">
              <q-input v-model="localForm.anio_inicial" label="Año Inicial" type="number" filled></q-input>
            </div>
            <div class="col-12">
              <q-input v-model="localForm.direccion" label="Dirección" filled @input="localForm.direccion = $event.toUpperCase()"></q-input>
            </div>
            <div class="col-12">
              <q-input v-model="localForm.telefono" label="Teléfono" filled @input="localForm.telefono = $event.toUpperCase()"></q-input>
            </div>
            <div class="col-12">
              <q-input v-model="localForm.resumen" label="Resumen" type="textarea" filled @input="localForm.resumen = $event.toUpperCase()"></q-input>
            </div>
            <!-- ///////////////////////////////// -->
            <div class="col-12">
              <q-file v-model="imageFile" label="Subir portada (solo JPG)" accept=".jpg,.jpeg" max-files="1" outlined dense @update:model-value="handleImageUpload">
                <template v-slot:prepend>
                  <q-icon name="attach_file" />
                </template>
              </q-file>
              <!-- Previsualización de la imagen -->
              <q-img v-if="imagePreview" :src="imagePreview" style="max-width: 200px; max-height: 200px; margin-top: 10px" class="q-mt-sm"></q-img>
            </div>
            <!-- ///////////////////////////////// -->
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
