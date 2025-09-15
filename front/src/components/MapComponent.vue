<template>
  <q-page>
    <div class="row relative-position">
      <!-- Mapa -->
      <div ref="mapContainer" class="col-xs-12 col-md-6 map-container"></div>
      <!-- Contenedor de cards (fuera del flujo normal) -->
      <div
        ref="cardsContainer"
        class="cards-container"
        :class="{ visible: showTable }"
      >
        <q-card class="q-ma-md">
          <!-- Botón de cerrar -->
          <q-btn
            icon="cleaning_services"
            flat
            round
            dense
            @click="mostrarDataNacional"
            title="Mostrar data nacional"
            class="close-btn"
          />
          <!-- Cards con la data del estado -->
          <div class="q-pa-md cards-grid">
            <q-card
              v-for="(value, key) in selectedStateData"
              :key="key"
              class="small-card q-mb-sm"
            >
              <q-card-section class="small-section">
                <div class="text-h6 small-title">{{ formatKey(key) }}</div>
                <div class="text-subtitle1 small-text">{{ value }}</div>
              </q-card-section>
            </q-card>
          </div>
        </q-card>
      </div>
    </div>
  </q-page>
</template>
<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import { Notify } from "quasar";
import axios from "axios";
import "leaflet/dist/leaflet.css";
import L from "leaflet";
import venezuelaGeoJsonData from "../geojson/Venezuela.json";
import socket from "src/services/websocket"; // Importar el servicio de WebSocket
import { useSelectedStateStore } from "src/stores/selectedState";

const mapContainer = ref(null);
const cardsContainer = ref(null);
const VITE_GR_ESTADOS_URL = import.meta.env.VITE_GR_ESTADOS_URL;
const VITE_DATA_ESTADOS_BASE_URL = import.meta.env.VITE_DATA_ESTADOS_BASE_URL;
const VITE_DATA_NACIONAL_BASE_URL = import.meta.env.VITE_DATA_NACIONAL_BASE_URL;
const showTable = ref(false);
const selectedStateData = ref({});
const estadoData = ref([]);
const paisData = ref([]);
let map = null; // Referencia al mapa de Leaflet
let geoJsonLayer = null; // Referencia a la capa GeoJSON
const selectedStateStore = useSelectedStateStore();

// Función para mostrar la data nacional en la tabla y en los gráficos
const mostrarDataNacional = async () => {
  const paisInfo = await fetchPaisInfo();
  selectedStateData.value = paisInfo;
  showTable.value = true;
  selectedStateStore.selectedState = null;
};
// const selectedStateStore = useSelectedStateStore();

const generateColorScale = () => {
  const colorScale = [];
  const step = 180 / 25; // Increment per step
  for (let i = 0; i < 26; i++) {
    if (i == 0) {
      colorScale.push(`rgb(255,255,255)`);
    } else {
      const green = Math.round(180 - i * step);
      colorScale.push(`rgb(${green}, ${green},255)`);
    }
  }
  return colorScale;
};
const colorScale = generateColorScale();
// Función para cargar los datos del mapa
const fetchEstadoData = async () => {
  try {
    const response = await axios.get(VITE_GR_ESTADOS_URL);
    return response.data;
  } catch (error) {
    Notify.create({
      message: "Error al obtener datos del estado.",
      color: "negative",
      position: "top",
      timeout: 3000,
    });
    return [];
  }
};
// Función para inicializar el mapa
const initializeMap = () => {
  // Destruir el mapa existente si hay uno
  if (map) {
    map.remove();
    map = null;
  }
  // Crear un nuevo mapa
  map = L.map(mapContainer.value).setView([8.0, -66.0], 5);
  // Agregar control de reinicio
  const resetControl = L.control({ position: "topright" });
  resetControl.onAdd = () => {
    const container = L.DomUtil.create("div", "reset-icon-container");
    const btn = L.DomUtil.create("button", "reset-icon-btn", container);
    btn.innerHTML = '<i class="fas fa-map-marker-alt"></i>';
    btn.style =
      "background-color: rgb(0, 0, 255) !important; color: rgb(255, 255, 255) !important; padding: 5px !important; cursor: pointer !important";
    btn.title = "Recentrar Mapa";
    L.DomEvent.on(btn, "click", () => {
      map.setView([8.0, -66.0], 5);
    });
    return container;
  };
  map.addControl(resetControl);
  // Ocultar el control de atribución
  const attributionControl = map
    .getContainer()
    .querySelector(".leaflet-control-attribution");
  if (attributionControl) {
    attributionControl.style.display = "none";
  }
  // Ocultar el control de zoom
  const zommControl = map.getContainer().querySelector(".leaflet-control");
  if (zommControl) {
    zommControl.style.display = "none";
  }
};
// Función para actualizar el mapa con nuevos datos
const updateMap = async () => {
  estadoData.value = await fetchEstadoData();
  const estadoMap = estadoData.value.reduce((acc, item) => {
    acc[item.estado.toLowerCase().replace(/ /g, "")] = item.cant_estado;
    return acc;
  }, {});
  const maxEstadoValue =
    Math.max(...estadoData.value.map((item) => item.cant_estado || 0)) || 1;
  // Eliminar la capa GeoJSON existente si hay una
  if (geoJsonLayer) {
    map.removeLayer(geoJsonLayer);
  }
  // Agregar una nueva capa GeoJSON con los datos actualizados
  geoJsonLayer = L.geoJSON(venezuelaGeoJsonData, {
    style(feature) {
      const normalizedEstado = feature.properties.name
        .toLowerCase()
        .replace(/ /g, "");
      const cant_estado = estadoMap[normalizedEstado] || 0;
      const normalizedValue = Math.min(cant_estado / maxEstadoValue, 1);
      const colorIndex = Math.floor(normalizedValue * 25);
      return {
        fillColor: colorScale[colorIndex] || colorScale[0],
        weight: 1,
        color: "#000000",
        fillOpacity: 0.7,
      };
    },
    onEachFeature(feature, layer) {
      const normalizedEstado = feature.properties.name
        .toLowerCase()
        .replace(/ /g, "");
      const cant_estado = estadoMap[normalizedEstado] || 0;
      const normalizedValue = Math.min(cant_estado / maxEstadoValue, 1);
      const colorIndex = Math.floor(normalizedValue * 25);
      const fillColor = colorScale[colorIndex] || colorScale[0];
      layer.bindTooltip(`${feature.properties.name}: ${cant_estado}`);
      layer.on("mouseover", () => {
        layer.setStyle({
          fillColor: "rgb(0, 0, 255)",
          weight: 1,
          color: "#000000",
          fillOpacity: 1,
        });
        layer.bringToFront();
        const bounds = layer.getBounds();
        const centerLatLng = bounds.getCenter();
        const centerPixel = map.latLngToContainerPoint(centerLatLng);
        layer._path.style.transformOrigin = `${centerPixel.x}px ${centerPixel.y}px`;
        layer._path.style.transform = "scale(1)";
      });
      layer.on("mouseout", () => {
        layer.setStyle({
          fillColor,
          weight: 1,
          color: "#000000",
          fillOpacity: 0.7,
        });
        layer._path.style.transform = "";
        layer._path.style.transformOrigin = "";
      });
      layer.on("click", async () => {
        const estadoName = feature.properties.name.toLowerCase();
        const estadoInfo = await fetchEstadoInfo(estadoName);
        const paisInfo = await fetchPaisInfo();
        if (JSON.stringify(estadoInfo).length == 2) {
          selectedStateData.value = paisInfo;
          showTable.value = true;
          selectedStateStore.selectedState = null; // nacional
        } else {
          selectedStateData.value = estadoInfo;
          showTable.value = true;
          selectedStateStore.selectedState = estadoName; // estado seleccionado
        }
      });
    },
  }).addTo(map);
};
// Función para obtener la información nacional
const fetchPaisInfo = async () => {
  try {
    const response = await axios.get(VITE_DATA_NACIONAL_BASE_URL);
    const paisInfo = response.data[0];
    return paisInfo || {};
  } catch (error) {
    Notify.create({
      message: "Falla al obtener información del estado.",
      color: "negative",
      position: "top",
      timeout: 3000,
    });
    return {};
  }
};
// Función para obtener la información de un estado específico
const fetchEstadoInfo = async (estadoName) => {
  try {
    const response = await axios.get(VITE_DATA_ESTADOS_BASE_URL);
    const estadoInfo = response.data.find(
      (item) => item.estado.toLowerCase() === estadoName
    );
    return estadoInfo || {};
  } catch (error) {
    Notify.create({
      message: "Falla al obtener información del estado.",
      color: "negative",
      position: "top",
      timeout: 3000,
    });
    return {};
  }
};
onMounted(async () => {
  // Inicializar el mapa
  initializeMap();
  // Cargar los datos iniciales del mapa
  await updateMap();
  const paisInfo = await fetchPaisInfo();
  selectedStateData.value = paisInfo;
  showTable.value = true;

  // Escuchar eventos de actualización desde WebSocket
  socket.onmessage = async (event) => {
    // Notify.create({
    //   message: "Cambio detectado en la base de datos. Actualizando mapa.",
    //   color: "positive",
    //   position: "top",
    //   timeout: 3000,
    // });
    await updateMap(); // Actualizar el mapa con los nuevos datos
    const updatedPaisInfo = await fetchPaisInfo();
    selectedStateData.value = updatedPaisInfo;
  };
});
onUnmounted(() => {
  // Limpiar el listener del WebSocket
  socket.onmessage = null;
});
// Función para formatear las claves de la data
const formatKey = (key) => {
  const formattedKey = key
    .replace(/_/g, " ") // Reemplazar guiones bajos por espacios
    .replace(/\b\w/g, (char) => char.toUpperCase()); // Capitalizar cada palabra
  return formattedKey;
};
</script>
<style scoped>
.map-container {
  height: 300px;
  background-color: #ffffff !important;
}

@media (min-width: 768px) {
  .map-container {
    height: 400px;
  }
}

/* Contenedor de cards (fuera del flujo normal) */
.cards-container {
  position: absolute;
  top: 0;
  left: 50%;
  width: 50%;
  max-height: 100%;
  /* Limita la altura al 100% del contenedor padre */
  overflow-y: auto;
  /* Permite el desplazamiento vertical si el contenido es demasiado grande */
  visibility: hidden;
  opacity: 0;
  transition: opacity 0.3s ease, visibility 0.3s ease;
  z-index: 10;
}

.cards-container.visible {
  visibility: visible;
  opacity: 1;
}

@media (max-width: 767px) {
  .cards-container {
    top: 100%;
    left: 0;
    width: 100%;
    max-height: 300px;
    /* Altura máxima para dispositivos móviles */
  }
}

/* Estilos para el botón de cerrar */
.close-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  z-index: 20;
}

/* Nuevos estilos para las cards */
.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 0.5rem;
}

.small-card {
  max-width: 180px;
  padding: 0.5rem;
  margin-bottom: 0.5rem;
}

.small-section {
  padding: 0.5rem 0.75rem !important;
}

.small-title {
  font-size: 0.8rem !important;
  margin-bottom: 0.2rem !important;
}

.small-text {
  font-size: 0.7rem !important;
  line-height: 1.1 !important;
}

/* Ajustes responsive */
@media (max-width: 767px) {
  .cards-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 0.5rem;
  }

  .small-card {
    max-width: 150px;
  }

  .small-title {
    font-size: 0.7rem !important;
  }

  .small-text {
    font-size: 0.6rem !important;
  }
}

/* Estilos para las cards individuales */
.q-card {
  transition: transform 0.2s ease;
}

.q-card:hover {
  transform: scale(1.02);
}
</style>
