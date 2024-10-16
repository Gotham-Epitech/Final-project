// src/router/index.js

import { createRouter, createWebHistory } from 'vue-router';

// Views
import Login from '../views/Login.vue';
import Landing from '../views/Landing.vue';
import Dashboard from '../views/Dashboard.vue';
import Profile from '../views/Profile.vue';

// Components

// Styles

// Routes

const routes = [
  {
    path: '/',
    name: 'Landing',
    component: Landing,
  },
  {
    path: '/login',
    name: 'Login',
    component: Login,
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: Dashboard,
  },
  {
    path: '/profile',
    name: 'Profile',
    component: Profile,
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
