<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { useRoute } from 'vue-router';

const route = useRoute();
const userId = ref(route.params.userID);
const workingTimes = ref([]);
const loading = ref(false);

const getWorkingTimes = async () => {
  loading.value = true;
  try {
    const response = await axios.get(`http://127.0.0.1:4000/api/workingtime/${userId.value}`);
    workingTimes.value = response.data;
    loading.value = false;
  } catch (error) {
    console.error('Error fetching working times:', error);
    loading.value = false;
  }
};

onMounted(() => {
  getWorkingTimes();
});
</script>

<template>
  <div class="p-4">
    <h2 class="text-xl font-semibold mb-4">Working Times for User ID: {{ userId }}</h2>
    <div v-if="loading" class="text-gray-500">Loading...</div>
    <table v-if="!loading" class="min-w-full bg-white">
      <thead>
        <tr>
          <th class="py-2">ID</th>
          <th class="py-2">Start Time</th>
          <th class="py-2">End Time</th>
          <th class="py-2">Duration (hrs)</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="wt in workingTimes" :key="wt.id" class="text-center">
          <td class="py-2">{{ wt.id }}</td>
          <td class="py-2">{{ wt.start }}</td>
          <td class="py-2">{{ wt.end }}</td>
          <td class="py-2">
            {{
              ((new Date(wt.end) - new Date(wt.start)) / (1000 * 60 * 60)).toFixed(2)
            }}
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style scoped>
/* Tailwind CSS handles styling */
</style>
