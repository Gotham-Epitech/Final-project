<script setup>
import { ref, onMounted } from 'vue';
import { Bar } from 'vue-chartjs';
import axios from 'axios';
import { useRoute } from 'vue-router';
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
} from 'chart.js';

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);

const route = useRoute();
const userId = route.params.userid;

const chartData = ref(null);
const chartOptions = ref({
  responsive: true,
  maintainAspectRatio: false,
});

onMounted(async () => {
  try {
    const response = await axios.get(`http://127.0.0.1:4000/api/workingtime/${userId}`);
    const workingTimes = response.data;

    const labels = workingTimes.map((wt) => {
      const date = new Date(wt.start);
      return date.toLocaleDateString();
    });

    const durations = workingTimes.map((wt) => {
      const start = new Date(wt.start);
      const end = new Date(wt.end);
      const duration = (end - start) / (1000 * 60 * 60); // Duration in hours
      return duration.toFixed(2);
    });

    chartData.value = {
      labels: labels,
      datasets: [
        {
          label: 'Working Hours',
          data: durations,
          backgroundColor: '#fb923c', // Orange-400
        },
      ],
    };
  } catch (error) {
    console.error('Error fetching working times:', error);
  }
});
</script>

<template>
  <div class="flex justify-center items-center h-full">
    <div class="w-full max-w-4xl">
      <Bar v-if="chartData" :chart-data="chartData" :chart-options="chartOptions" />
      <div v-else class="text-center text-gray-500">Loading chart data...</div>
    </div>
  </div>
</template>

<style scoped>
/* No additional styles needed as Tailwind CSS is used */
</style>
