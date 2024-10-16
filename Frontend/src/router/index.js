// src/router/index.js

import { createRouter, createWebHistory } from 'vue-router';

// Views
// import Login from './Login.vue';
import AuthView from '../views/AuthView.vue';
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
    path: '/Auth',
    name: 'AuthView',
    component: AuthView,
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
  },
  // {
  //   path: '/signup',
  //   name: 'Signup',
  //   component: Signup,
  // },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
