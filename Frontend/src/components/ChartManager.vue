<script setup>
import { useRoute } from 'vue-router';

const route = useRoute();
const userId = route.params.userid;
</script>

<template>
  <div>
    <h2>Chart Manager for User ID: {{ userId }}</h2>
    <nav>
      <router-link :to="{ name: 'BarChart', params: { userid: userId } }">Bar Chart</router-link> |
      <router-link :to="{ name: 'LineChart', params: { userid: userId } }">Line Chart</router-link> |
      <router-link :to="{ name: 'PieChart', params: { userid: userId } }">Pie Chart</router-link>
    </nav>
    <router-view />
  </div>
</template>

<style scoped>
nav {
  margin: 20px 0;
}

nav a {
  margin: 0 10px;
  text-decoration: none;
  color: #42b983;
}

nav a.router-link-active {
  font-weight: bold;
}
</style>
