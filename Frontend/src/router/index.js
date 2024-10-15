// src/router/index.js

import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import LoginView from '../views/LoginView.vue';
import User from '../components/User.vue';
import WorkingTimes from '../components/WorkingTimes.vue';
import WorkingTime from '../components/WorkingTime.vue';
import ClockManager from '../components/ClockManager.vue';
import ChartManager from '../components/ChartManager.vue';
import BarChart from '../components/BarChart.vue';
import LineChart from '../components/LineChart.vue';
import PieChart from '../components/PieChart.vue';

const routes = [
  {
    path: '/',
    name: 'HomeView',
    component: HomeView,
  },
  {
    path: '/users',
    name: 'LoginView',
    component: LoginView,
  },
  {
    path: '/users/:userId/workingtimes',
    name: 'WorkingTimes',
    component: WorkingTimes,
    props: true,
  },
  {
    path: '/users/:userId/workingtimes/:workingTimeId',
    name: 'WorkingTime',
    component: WorkingTime,
    props: true,
  },
  {
    path: '/users/:userId/clocks',
    name: 'ClockManager',
    component: ClockManager,
    props: true,
  },
  {
    path: '/chartManager/:userid',
    name: 'ChartManager',
    component: ChartManager,
    props: true,
    children: [
      {
        path: 'barChart',
        name: 'BarChart',
        component: BarChart,
        props: true,
      },
      {
        path: 'lineChart',
        name: 'LineChart',
        component: LineChart,
        props: true,
      },
      {
        path: 'pieChart',
        name: 'PieChart',
        component: PieChart,
        props: true,
      },
    ],
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
