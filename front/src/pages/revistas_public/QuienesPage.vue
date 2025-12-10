<template>
  <!-- (Mantener template existente sin cambios) -->
  <div class="row justify-center q-mt-md q-mb-md">
    <div class="col-auto text-center">
      <img alt="Logo" src="img/logo-nobg1.png" class="responsive-logo" />
    </div>
  </div>

  <div class="q-ml-md q-mr-md q-mb-xl sections-wrapper">
    <div class="row items-stretch no-wrap">
      <div class="col-12 q-mb-xl q-px-sm ">
        <div class="text-left">
          <p class="q-mb-xs q-mt-none q-mb-md q-mt-md text-left text-bold q-mb-none q-mt-none"
            :class="{ 'q-ml-xl': $q.screen.gt.sm, 'q-ml-none': !$q.screen.gt.sm, 'text-h4': $q.screen.gt.sm, 'text-h6': !$q.screen.gt.sm }"
            :style="!$q.screen.gt.sm ? 'font-size:22px;' : 'font-size:36px; font-family: Gotham Bold;'">
            QUIÉNES SOMOS
          </p>
          <p :class="{ 'q-ml-xl': $q.screen.gt.sm, 'q-ml-none': !$q.screen.gt.sm }"
            :style="!$q.screen.gt.sm ? 'font-size:15px;' : ''">
            El «Directorio Nacional de Revistas Científicas» constituye un proyecto de divulgación científica de
            excepcional relevancia, liderado por el Observatorio Nacional de Ciencia, Tecnología e Innovación (Oncti),
            ente que se erige como instrumento sustantivo del órgano competente en materia de ciencia, tecnología,
            innovación y sus aplicaciones, el Ministerio del Poder Popular para Ciencia y Tecnología (Mincyt). El equipo
            responsable de la dirección y supervisión del proyecto está compuesto por los siguientes miembros:
          </p>
          <div class="row q-col-gutter-md vcard-row-mobile-fix" :class="{ 'q-ml-xl': $q.screen.gt.sm }">
            <div class="col-12 col-md-6">
              <q-card>
                <q-card-section class="row items-center">
                  <div class="vcard-flex-wrap">
                    <div class="vcard-img-col">
                      <q-img :src="`${VITE_IMAGE_BASE_URL}betancourt.png`" alt="Foto Betancourt"
                        style="width:60px; height:60px; border-radius:50%; object-fit:cover;" />
                    </div>
                    <div class="vcard-info-col">
                      <div class="text-h6 text-bold">Dr. Roberto Betancourt A.</div>
                      <div class="text-body2">Presidente del Observatorio Nacional de Ciencia, Tecnología e Innovación
                      </div>
                      <div class="vcard-email-align text-body2 text-bold"><a href="mailto:robertoabetancourt@gmail.com"
                          style="color:blue;">roberto.betancourt@oncti.gob.ve</a></div>
                    </div>
                  </div>
                </q-card-section>
              </q-card>
            </div>
            <div class="col-12 col-md-6">
              <q-card>
                <q-card-section class="row items-center">
                  <div class="vcard-flex-wrap">
                    <div class="vcard-img-col">
                      <q-img :src="`${VITE_IMAGE_BASE_URL}ortuzar.png`" alt="Foto Ortúzar"
                        style="width:60px; height:60px; border-radius:50%; object-fit:cover;" />
                    </div>
                    <div class="vcard-info-col">
                      <div class="text-h6 text-bold">Lic. Fabiola Ortúzar</div>
                      <div class="text-body2">Gerente de Divulgación</div>
                      <div class="vcard-email-align text-body2 text-bold"><a href="mailto:divulgación@oncti.gob.ve"
                          style="color:blue;">divulgación@oncti.gob.ve</a></div>
                    </div>
                  </div>
                </q-card-section>
              </q-card>
            </div>
            <div class="col-12 col-md-6">
              <q-card>
                <q-card-section class="row items-center">
                  <div class="vcard-flex-wrap">
                    <div class="vcard-img-col">
                      <q-img :src="`${VITE_IMAGE_BASE_URL}araujo.png`" alt="Foto Araujo"
                        style="width:60px; height:60px; border-radius:50%; object-fit:cover;" />
                    </div>
                    <div class="vcard-info-col">
                      <div class="text-h6 text-bold">Lic. Zenaida Araujo</div>
                      <div class="text-body2">Coordinadora de Publicaciones</div>
                      <div class="vcard-email-align text-body2 text-bold"><a href="mailto:zaraujo@oncti.gob.ve"
                          style="color:blue;">zaraujo@oncti.gob.ve</a></div>
                    </div>
                  </div>
                </q-card-section>
              </q-card>
            </div>
            <div class="col-12 col-md-6">
              <q-card>
                <q-card-section class="row items-center">
                  <div class="vcard-flex-wrap">
                    <div class="vcard-img-col">
                      <q-img :src="`${VITE_IMAGE_BASE_URL}arvelo.png`" alt="Foto Arvelo"
                        style="width:60px; height:60px; border-radius:50%; object-fit:cover;" />
                    </div>
                    <div class="vcard-info-col">
                      <div class="text-h6 text-bold">Ing. Mónica Arvelo</div>
                      <div class="text-body2">Directora de la Oficina de Tecnologías de la Información y la Comunicación
                      </div>
                      <div class="vcard-email-align text-body2 text-bold"><a href="mailto:marvelo@oncti.gob.ve"
                          style="color:blue;">marvelo@oncti.gob.ve</a></div>
                    </div>
                  </div>
                </q-card-section>
              </q-card>
            </div>
            <div class="col-12 col-md-6">
              <q-card>
                <q-card-section class="row items-center">
                  <div class="vcard-flex-wrap">
                    <div class="vcard-img-col">
                      <q-img :src="`${VITE_IMAGE_BASE_URL}morales.png`" alt="Foto Morales"
                        style="width:60px; height:60px; border-radius:50%; object-fit:cover;" />
                    </div>
                    <div class="vcard-info-col">
                      <div class="text-h6 text-bold">Dr. Gregorio Morales</div>
                      <div class="text-body2">Asesor</div>
                      <div class="vcard-email-align text-body2 text-bold"><a href="mailto:gmorales@oncti.gob.ve"
                          style="color:blue;">gmorales@oncti.gob.ve</a></div>
                    </div>
                  </div>
                </q-card-section>
              </q-card>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>


  <!-- Sección de pie -->
  <div class="q-pa-xl footer-sections">
    <div class="row q-col-gutter-xs center-around footer-container">
      <div class="column footer-column">
        <q-img :src="logoBlanco" alt="Logo" />
        <div class="text-h7 q-mt-md">Síguenos</div>
        <div class="row q-gutter-md q-mt-sm">
          <q-icon name="mdi-instagram" size="30px" />
          <q-icon name="mdi-youtube" size="30px" />
        </div>
      </div>
      <div class="column footer-column">
        <div class="text-h6 q-mb-sm" style="font-family: Gotham Bold;">Enlaces</div>
        <div class="text-h7 text-white" title="Observatorio Nacional de Ciencia, Tecnología e Innovación">
          <a class="mostrar" href="https://www.oncti.gob.ve/">→ ONCTI</a>
          <a class="ocultar" href="https://www.oncti.gob.ve/">→ Observatorio Nacional de Ciencia, tecnología e
            Innovación</a>
        </div>
        <div class="text-h7 text-white" title="Observatorio en Línea">
          <a class="mostrar" href="https://observatorio.oncti.gob.ve/#/">→ OEL</a>
          <a class="ocultar" href="https://observatorio.oncti.gob.ve/#/">→ Observatorio en Línea</a>
        </div>
      </div>
      <div class="column footer-column">
        <div class="text-h6 q-mb-sm" style="font-family: Gotham Bold;">Novedades</div>
        <div class="row q-pa-sm" style="border: 1px solid white; border-radius: 8px; margin-bottom: 10px;">
          <div class="col-3"><q-img :src=portada1 width="50px" height="60px" /></div>
          <div class="col-9 flex items-center">{{ revista1 }}</div>
        </div>
        <div class="row q-pa-sm" style="border: 1px solid white; border-radius: 8px;">
          <div class="col-3"><q-img :src=portada2 width="50px" height="60px" /></div>
          <div class="col-9 flex items-center">{{ revista2 }}</div>
        </div>
      </div>
      <div class="column footer-column">
        <div class="text-h6 q-mb-sm" style="font-family: Gotham Bold;">Contactos</div>
        <div class="row items-start q-mb-sm">
          <q-img :src="ubicacionImg" style="width: 20px; height: 20px; margin-right: 8px;" />
          <div class="text-body2">
            Avenida Universidad, esquina El Chorro, <br />Torre Ministerial, piso 16, La Hoyada, <br /> Caracas,
            Distrito Capital
          </div>
        </div>
        <div class="row items-center q-mb-sm">
          <q-img :src="correoImg" style="width: 20px; height: 20px; margin-right: 8px;" />
          <div class="text-body2">Correoelectronico@gmail.com</div>
        </div>
        <q-img :src="logoOncti" style="width: 120px; margin-top: 10px;" />
      </div>
    </div>
  </div>
  <!-- Sección de pie -->
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue';
import axios from 'axios';
import { Notify, useQuasar } from "quasar";
import socket from "src/services/websocket.js";
import fondoInicio from 'src/assets/img/fondo_inicio.png';
import estadisticas from 'src/assets/img/estadisticas.png';
import publicaciones from 'src/assets/img/publicaciones.png';
import logoBlanco from 'src/assets/img/logo_blanco.png'
import ubicacionImg from 'src/assets/img/ubicacion.png'
import correoImg from 'src/assets/img/correo.png'
import logoOncti from 'src/assets/img/logo_oncti_blanco.png'
const $q = useQuasar();
const VITE_IMAGE_INICIO_URL = import.meta.env.VITE_IMAGE_INICIO_URL;
const VITE_RECIENTES_URL = import.meta.env.VITE_RECIENTES_URL;
const VITE_IMAGE_BASE_URL = import.meta.env.VITE_IMAGE_BASE_URL;
const VITE_SC_INSERT_URL = import.meta.env.VITE_SC_INSERT_URL;
const secciones = ref([]);
const sectionRefs = ref([]);
const recientes = ref([]);
const portada1 = ref();
const portada2 = ref();
const revista1 = ref();
const revista2 = ref();
const email = ref('');
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const loading = ref(false);
//////////////
let socketMessageHandler = null;
//////////////
const CACHE_KEY = 'seccionesHomeCache';
const isValidCache = (data) => {
  return Array.isArray(data) &&
    data.length === 2 &&
    data.every(item => item.titulo && item.contenido);
};
const procesarDatos = (data) => {
  return data.sort((a, b) => a.orden - b.orden).slice(0, 2);
};
//////////////
const backgroundStyle = computed(() => ({
  backgroundImage: `url(${fondoInicio})`,
  aspectRatio: '8000 / 1855'
}));

// const cargarSecciones = async () => {
const cargarSecciones = async (usarCache = true) => {
  // Cargar revistas recientes (no debe bloquear el resto de la página)
  try {
    recientes.value = await axios.get(VITE_RECIENTES_URL);
    portadas(recientes.value);
  } catch (err) {
    console.warn('No se pudieron cargar las revistas recientes:', err.message);
    // No bloquear la carga de la página
  }
  try {
    if (usarCache) {
      const cached = localStorage.getItem(CACHE_KEY);
      if (cached) {
        const parsed = JSON.parse(cached);
        if (isValidCache(parsed)) {
          secciones.value = parsed; // Usar parsed del caché
          return;
        }
      }
    }

    // Si no hay caché o es inválido, hacer fetch
    const response = await axios.get(VITE_IMAGE_INICIO_URL);
    const procesadas = procesarDatos(response.data); // Variable local al bloque
    secciones.value = procesadas;
    localStorage.setItem(CACHE_KEY, JSON.stringify(procesadas));
  } catch (error) {
    console.error('Error:', error);
    if (!secciones.value.length) { // Verificar si no hay datos
      Notify.create({ message: "Error al cargar", color: "negative" });
    }
  }
};

const configurarObserver = () => {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        entry.target.classList.toggle("visible", entry.isIntersecting);
        entry.target.classList.toggle("inactive", !entry.isIntersecting);
      });
    },
    { threshold: 0.1 }
  );

  sectionRefs.value.forEach((section) => section && observer.observe(section));
};

const enviar = async () => {
  if (!email.value) {
    Notify.create({
      message: 'El campo correo es requerido',
      color: 'negative'
    });
    return;
  }

  if (!emailRegex.test(email.value)) {
    Notify.create({
      message: 'El formato del correo electrónico no es válido',
      color: 'negative'
    });
    return;
  }
  loading.value = true;
  try {
    const response = await axios.post(VITE_SC_INSERT_URL, {
      correo: email.value
    });
    Notify.create({
      message: response.data.length > 0 ? response.data : "Correo ya registrado",
      color: response.status === 201 ? 'positive' : 'negative'
    });

    if (response.status === 201) {
      email.value = '';
    }
  } catch (error) {
    const status = error.response?.status;
    const message = error.response?.data?.mensaje || 'Error al enviar el correo';

    Notify.create({
      message: message,
      color: [400, 500].includes(status) ? 'negative' : 'negative'
    });
  } finally {
    loading.value = false;
  }
};
const portadas = (portadasResponse) => {
  const data = portadasResponse?.data || [];
  if (data.length > 0) {
    portada1.value = VITE_IMAGE_BASE_URL + data[0].portada;
    revista1.value = data[0].revista;
  }
  if (data.length > 1) {
    portada2.value = VITE_IMAGE_BASE_URL + data[1].portada;
    revista2.value = data[1].revista;
  }
}
onMounted(async () => {
  await cargarSecciones(true);
  configurarObserver();
  socketMessageHandler = async () => {
    try {
      await cargarSecciones(false);
      // Notify.create({ message: "Contenido actualizado", color: "positive" });
    } catch (error) {
      console.error('Error en WebSocket:', error);
    }
  };
  socket.addEventListener("message", socketMessageHandler);
  socket.addEventListener("message", async () => {
    try {
      // await cargarSecciones(false);
      await cargarSecciones();
      Notify.create({ message: "Contenido actualizado", color: "positive", timeout: 2000 });
    } catch (error) {
      console.error('Error en WebSocket:', error);
      Notify.create({ message: "Error al actualizar", color: "negative", timeout: 3000 });
    }
  });
});
onUnmounted(() => {
  if (socketMessageHandler) {
    socket.removeEventListener("message", socketMessageHandler); // <-- Eliminar con misma referencia
    socketMessageHandler = null;
  }
});

</script>

<style scoped>
.sections-wrapper {
  position: relative;
}

.responsive-logo {
  width: 100%;
  max-width: 500px;
  height: auto;
  padding: 0 20px;
}

.desktop-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  z-index: 0;
  display: none;
}

.section-container {
  position: relative;
  z-index: 1;
  min-height: 300px;
  display: flex;
  align-items: center;
}

.content-wrapper {
  padding: 30px;
  color: white;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
  width: 100%;
}

.animated {
  opacity: 0;
  transform: translateY(20px);
  transition: all 0.6s ease-out;
}

.visible .animated {
  opacity: 1;
  transform: translateY(0);
}

.footer-sections {
  background-color: #243b86;
  color: white;
}

.footer-container {
  display: flex;
  justify-content: center;
  gap: 5px;
  margin: 0 auto;
  max-width: 1200px;
  padding: 0 40px;
}

.footer-column {
  min-width: 200px;
  position: relative;
}

a {
  color: white;
  text-decoration: none;
  /* Opcional: para quitar la subrayado por defecto */
}

/* Estilo para los enlaces visitados */
a:visited {
  color: white;
}

.mostrar {
  display: block;
}

.ocultar {
  display: none;
}

.q-card {
  margin-bottom: 16px;
}

@media (min-width: 768px) {
  .suscribir {
    width: 400px;
  }

  .desktop-background {
    display: block;
  }

  .sections-wrapper {
    overflow: hidden;
    border-radius: 12px;
    padding: 0 10px;
  }

  .row.no-wrap {
    margin: 0 -5px;
  }

  .section-container {
    width: calc(50% - 10px);
    margin: 0 5px;
    padding: 0;
  }

  .content-wrapper {
    width: 95%;
    padding: 25px;
  }

  .section-container:first-child .content-wrapper {
    margin-right: -5%;
    padding-right: 30px;
  }

  .section-container:last-child .content-wrapper {
    margin-left: -5%;
    padding-left: 30px;
  }

  .footer-container {
    flex-direction: row;
  }

  .footer-column:nth-child(1) {
    flex: 0 0 2%;
  }

  .footer-column:nth-child(2) {
    flex: 0 0 1%;
    padding-left: 20px;
    margin-right: -40px;
  }

  .footer-column:nth-child(3) {
    flex: 0 0 25%;
    margin-right: 20px !important;
  }

  .footer-column:nth-child(4) {
    flex: 0 0 30%;
  }

  .footer-column:nth-child(1) .content-wrapper {
    margin-left: 0 !important;
    margin-right: auto !important;
    width: 100% !important;
    text-align: left !important;
  }


}

@media (max-width: 400px) {
  .suscribir {
    width: 300px !important;
  }
}

@media (max-width: 767px) {
  .row.no-wrap {
    flex-wrap: wrap !important;
  }

  .mostrar {
    display: none;
  }

  .ocultar {
    display: block;
  }

  .section-container {
    width: 100% !important;
    max-width: 100% !important;
    margin: 0 0 20px 0 !important;
  }

  .sections-wrapper {
    padding: 15px !important;
  }

  .content-wrapper {
    text-align: left !important;
    padding: 20px 15px !important;
  }

  .section-container:last-child {
    margin-bottom: 0 !important;
  }

  .footer-container {
    flex-direction: column;
    padding: 0;
  }

  .footer-column {
    margin-bottom: 20px;
    width: 100%;
  }
}

.container {
  max-width: 1000px;
  margin: auto;
  padding: 20px;
}

.title {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 20px;
}

.table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 20px;
}

.table th,
.table td {
  border: 1px solid #ccc;
  padding: 10px;
  text-align: left;
}

.table th {
  background-color: #f5f5f5;
}

.actions {
  display: flex;
  gap: 10px;
}

.button {
  padding: 8px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.button.edit {
  background-color: #4CAF50;
  color: white;
}

.button.delete {
  background-color: #f44336;
  color: white;
}

.button.add {
  background-color: #2196F3;
  color: white;
  margin-bottom: 10px;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  font-weight: bold;
  margin-bottom: 5px;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.error {
  color: red;
  font-size: 12px;
  margin-top: 5px;
}

.modal {
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  max-width: 600px;
  margin: auto;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.modal-header {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 15px;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
}

.hidden {
  display: none;
}

/* Ajuste para que las vcards estén más a la izquierda en móvil */
.vcard-row-mobile-fix {
  padding-left: 0 !important;
}

/* Layout para vcard: imagen y correo siempre alineados */
.vcard-flex-wrap {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
}

.vcard-img-col {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  min-width: 60px;
  margin-right: 12px;
}

.vcard-info-col {
  flex: 1 1 0%;
  padding-right: 0;
}

.vcard-email-align {
  margin-top: 4px;
  margin-bottom: 2px;
  text-align: left;
  font-size: 15px;
  padding-left: 0;
  margin-left: 0;
}

@media (max-width: 767px) {
  .vcard-flex-wrap {
    flex-direction: row;
    align-items: flex-start;
  }

  .vcard-img-col {
    min-width: 60px;
    margin-right: 8px;
  }

  .vcard-email-align {
    max-width: 60px;
    width: 60px;
    padding-left: 0;
    margin-left: 0;
    text-align: left;
    font-size: 15px;
  }

  .vcard-row-mobile-fix {
    margin-left: 0 !important;
    padding-left: 0 !important;
  }

  .vcard-email-mobile-fix {
    text-align: left !important;
    padding-left: 0 !important;
    margin-left: 0 !important;
    font-size: 15px !important;
  }
}

@media (min-width: 768px) {
  .vcard-flex-wrap {
    flex-direction: row;
    align-items: flex-start;
  }

  .vcard-img-col {
    margin-right: 16px;
  }

  .vcard-email-align {
    max-width: none;
    width: auto;
    font-size: 15px;
    padding-left: 0;
    margin-left: 0;
  }

  .vcard-email-mobile-fix {
    padding-left: 12px;
  }
}

/* Large screens (1440px+) */
@media (min-width: 1440px) {
  .sections-wrapper {
    max-width: 1400px;
    margin: 0 auto;
  }

  .responsive-logo {
    max-width: 600px;
  }

  .footer-container {
    max-width: 1400px;
    gap: 40px;
  }

  .footer-column {
    min-width: 220px;
  }

  p {
    font-size: 18px;
    line-height: 1.6;
  }

  .vcard-img-col {
    min-width: 80px;
    margin-right: 20px;
  }
}

/* Extra large screens (1920px+) */
@media (min-width: 1920px) {
  .sections-wrapper {
    max-width: 1700px;
  }

  .responsive-logo {
    max-width: 700px;
  }

  .footer-container {
    max-width: 1600px;
    gap: 60px;
  }

  .footer-column {
    min-width: 250px;
  }

  p {
    font-size: 20px;
    line-height: 1.7;
  }

  .vcard-img-col {
    min-width: 90px;
    margin-right: 24px;
  }
}
</style>
