<script setup>
import { ref, onMounted } from 'vue';
import { Pie } from 'vue-chartjs';
import axios from 'axios';
import { useRoute } from 'vue-router';
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  ArcElement,
  CategoryScale,
} from 'chart.js';

ChartJS.register(Title, Tooltip, Legend, ArcElement, CategoryScale);

const route = useRoute();
const userId = route.params.userid;

const chartData = ref(null);
const chartOptions = ref({
  responsive: true,
  maintainAspectRatio: false,
});

onMounted(async () => {
  try {
    // Fetch working times data for the user
    const response = await axios.get(`http://127.0.0.1:4000/api/workingtime/${userId}`);
    const workingTimes = response.data;

    // Process data for the pie chart
    const dayTotals = {};

    workingTimes.forEach((wt) => {
      const date = new Date(wt.start);
      const day = date.toLocaleDateString('en-US', { weekday: 'long' });

      const start = new Date(wt.start);
      const end = new Date(wt.end);
      const duration = (end - start) / (1000 * 60 * 60); // Duration in hours

      if (dayTotals[day]) {
        dayTotals[day] += duration;
      } else {
        dayTotals[day] = duration;
      }
    });

    chartData.value = {
      labels: Object.keys(dayTotals),
      datasets: [
        {
          label: 'Working Hours by Day',
          data: Object.values(dayTotals),
          backgroundColor: [
            '#f87171', // Red-400
            '#60a5fa', // Blue-400
            '#fbbf24', // Yellow-400
            '#34d399', // Green-400
            '#a78bfa', // Purple-400
            '#f472b6', // Pink-400
            '#cbd5e1', // Slate-300
          ],
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
    <div class="w-full max-w-md">
      <Pie v-if="chartData" :chart-data="chartData" :chart-options="chartOptions" />
      <div v-else class="text-center text-gray-500">Loading chart data...</div>
    </div>
  </div>
</template>

<style scoped>
/* No additional styles needed as Tailwind CSS is used */
</style>
