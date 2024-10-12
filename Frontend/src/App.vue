<script setup>
import { RouterView } from 'vue-router';
import User from './components/User.vue';
</script>

<template>
  <div id="app">
    <p class="text-red-500">test</p>
    <!-- Include the User component -->
    <User />
    <!-- RouterView to render other components based on routes -->
    <RouterView />
  </div>
</template>

<style scoped>
/* Your styles here */
</style>
