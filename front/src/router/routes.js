const routes = [
  {
    path: "/",
    component: () => import("layouts/InitialLayout.vue"),
    children: [
      { path: "", component: () => import("pages/IndexPage.vue") },
      {
        path: "/revistas",
        component: () => import("pages/revistas_public/RevistasPage.vue"),
      },
      {
        path: "/estadisticas",
        component: () => import("pages/revistas_public/EstadisticasPage.vue"),
      },
      {
        path: "/login",
        component: () => import("pages/login/LoginPage.vue"),
        meta: { requiresGuest: true },
      },
    ],
  },
  {
    path: "/admin",
    component: () => import("layouts/MainLayout.vue"),
    meta: { requiresAuth: false },
    children: [
      {
        path: "",
        component: () => import("pages/revistas_private/MantenedorPage.vue"),
      },
    ],
  },
  {
    path: "/inicio",
    component: () => import("layouts/MainLayout.vue"),
    meta: { requiresAuth: false },
    children: [
      {
        path: "",
        component: () => import("pages/revistas_private/InicioPage.vue"),
      },
    ],
  },
  {
    path: "/:catchAll(.*)*",
    component: () => import("layouts/InitialLayout.vue"),
  },
];

export default routes;
