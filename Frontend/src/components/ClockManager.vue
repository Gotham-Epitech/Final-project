<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { useRoute } from 'vue-router';

const route = useRoute();
const userId = ref(route.params.userid);
const clockIn = ref(false);
const startDateTime = ref(null);

const refresh = async () => {
  try {
    const response = await axios.get(`http://127.0.0.1:4000/api/clocks/${userId.value}`);
    const clocks = response.data;
    if (clocks.length > 0 && !clocks[clocks.length - 1].end) {
      // User is clocked in
      clockIn.value = true;
      startDateTime.value = clocks[clocks.length - 1].start;
    } else {
      // User is not clocked in
      clockIn.value = false;
      startDateTime.value = null;
    }
  } catch (error) {
    console.error('Error refreshing clock status:', error);
  }
};

const clock = async () => {
  if (!clockIn.value) {
    // Clocking in
    startDateTime.value = new Date().toISOString().slice(0, 19);
    clockIn.value = true;
    try {
      await axios.post(`http://127.0.0.1:4000/api/clocks/${userId.value}`, {
        start: startDateTime.value,
      });
    } catch (error) {
      console.error('Error clocking in:', error);
    }
  } else {
    // Clocking out
    const endDateTime = new Date().toISOString().slice(0, 19);
    clockIn.value = false;
    try {
      // Assuming your API requires updating the last clock entry
      const response = await axios.get(`http://127.0.0.1:4000/api/clocks/${userId.value}`);
      const clocks = response.data;
      const lastClock = clocks[clocks.length - 1];
      await axios.put(`http://127.0.0.1:4000/api/workingtime/${lastClock.id}`, {
        end: endDateTime,
      });
      startDateTime.value = null;
    } catch (error) {
      console.error('Error clocking out:', error);
    }
  }
};

onMounted(() => {
  refresh();
});
</script>

<template>
  <div class="flex items-center justify-center min-h-screen">
    <div class="bg-white p-6 rounded-lg shadow-lg w-full max-w-md">
      <h2 class="text-2xl font-semibold mb-4 text-center">Clock Manager</h2>
      <div class="text-center mb-4">
        <p v-if="clockIn" class="text-green-500">
          Clocked in at: {{ startDateTime }}
        </p>
        <p v-else class="text-red-500">Not clocked in</p>
      </div>
      <button
        @click="clock"
        class="w-full bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
      >
        {{ clockIn ? 'Clock Out' : 'Clock In' }}
      </button>
    </div>
  </div>
</template>

<style scoped>
/* Tailwind CSS handles styling */
</style>
