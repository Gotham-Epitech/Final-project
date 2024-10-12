// src/router/index.js

import { createRouter, createWebHistory } from 'vue-router';
import ChartManager from '../components/ChartManager.vue';
import BarChart from '../components/BarChart.vue';
import LineChart from '../components/LineChart.vue';
import PieChart from '../components/PieChart.vue';

const routes = [
  // Other routes...
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
