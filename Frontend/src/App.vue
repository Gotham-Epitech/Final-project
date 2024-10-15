<script setup>
import { RouterView } from 'vue-router';
import User from './components/User.vue';
import HomeView from './views/HomeView.vue';
</script>

<template>
  <div id="app">
    <!-- RouterView to render other components based on routes -->
    <RouterView />
  </div>
</template>

<style scoped>
/* Your styles here */
</style>
