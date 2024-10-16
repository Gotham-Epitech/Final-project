<script setup>
import { RouterView } from 'vue-router';
import { ref } from 'vue';
import Login from '../components/Login.vue';
import Signup from '../components/Signup.vue';

const showLogin = ref(true);

const toggleForm = () => {
  showLogin.value = !showLogin.value;
};

</script>

<template>
  <div>
    <p>Auth</p>
    <Login v-if="showLogin" @switchToSignup="toggleForm" />
    <Signup v-else @switchToLogin="toggleForm" />

  </div>
</template>

<style scoped>
/* Your styles here */
</style>
