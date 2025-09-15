<template>
  <q-layout view="hHh lpR fFf">
    <q-header elevated class="bg-primary text-white">
      <q-toolbar>
        <q-btn dense flat round icon="menu" @click="toggleLeftDrawer" />

        <q-toolbar-title>
          <q-avatar>
            <img src="https://cdn.quasar.dev/logo-v2/svg/logo-mono-white.svg">
          </q-avatar>
          Directorio de Revistas Científicas Venezolanas
        </q-toolbar-title>

        <q-space />

        <q-btn flat round dense icon="logout" @click="logout" />
      </q-toolbar>
    </q-header>

    <q-drawer show-if-above v-model="leftDrawerOpen" side="left" elevated>
      <!-- Menú basado en permisos -->
      <q-list>
        <q-item-label header>Menú Principal</q-item-label>

        <q-item clickable v-ripple to="/inicio">
          <q-item-section avatar>
            <q-icon name="home" />
          </q-item-section>
          <q-item-section>Inicio</q-item-section>
        </q-item>
        <q-item clickable v-ripple to="/admin" v-if="hasPermission('view_admin')">
          <q-item-section avatar>
            <q-icon name="menu_book" />
          </q-item-section>
          <q-item-section>Revistas</q-item-section>
        </q-item>

        <!-- Agrega más items según los permisos -->
      </q-list>
    </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { LocalStorage, Notify } from 'quasar'
import axios from 'axios'

const leftDrawerOpen = ref(false)
const router = useRouter()
const logoutUrl = import.meta.env.VITE_LOGOUT_URL

const toggleLeftDrawer = () => {
  leftDrawerOpen.value = !leftDrawerOpen.value
}

const hasPermission = (permissionName) => {
  const permissions = LocalStorage.getItem('permissions') || []
  return permissions.some(p => p.name === permissionName)
}

const logout = async () => {
  try {
    const token = LocalStorage.getItem('token')

    // Llamar al endpoint de logout en el backend
    await axios.post(logoutUrl, {}, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    })

    // Limpiar el almacenamiento local
    LocalStorage.remove('token')
    LocalStorage.remove('permissions')

    Notify.create({
      message: 'Sesión cerrada correctamente',
      color: 'positive'
    })

    // Redirigir al login
    router.push('/login')
  } catch (error) {
    console.error('Error al cerrar sesión:', error)
    Notify.create({
      message: 'Error al cerrar sesión',
      color: 'negative'
    })
  }
}
</script>
