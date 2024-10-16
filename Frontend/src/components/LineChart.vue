<script>
// Import necessary Chart.js components using named imports
import {
  Chart,
  LineController,
  LineElement,
  PointElement,
  LinearScale,
  Title,
  CategoryScale,
  Tooltip,
  Legend
} from 'chart.js';

// Register the imported components with Chart.js
Chart.register(
  LineController,
  LineElement,
  PointElement,
  LinearScale,
  Title,
  CategoryScale,
  Tooltip,
  Legend
);

export default {
  name: "LineChart",
  mounted() {
    this.$nextTick(() => {
      // Helper function to convert "HH:MM" to total minutes
      const timeToMinutes = (time) => {
        const [hours, minutes] = time.split(':').map(Number);
        return hours * 60 + minutes;
      };
      // Helper function to convert total minutes to "HH:MM"
      const minutesToTime = (minutes) => {
        const hrs = Math.floor(minutes / 60);
        const mins = minutes % 60;
        return `${hrs}:${mins.toString().padStart(2, '0')}`;
      };
      // Define the chart configuration
      const config = {
        type: "line",
        data: {
          labels: [
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday",
            "Sunday"
          ],
          datasets: [
            {
              label: "Scheduled hours",
              backgroundColor: "#4c51bf",
              borderColor: "#4c51bf",
              data: [
                timeToMinutes("7:00"),
                timeToMinutes("7:00"),
                timeToMinutes("7:00"),
                timeToMinutes("7:00"),
                timeToMinutes("7:00"),
                timeToMinutes("7:00"),
                timeToMinutes("7:00"),],
              fill: false,
              tension: 0.1 // Adds slight curve to the line
            },
            {
              label: "Clocked hours",
              fill: false,
              backgroundColor: "#ed64a6",
              borderColor: "#ed64a6",
              data: [
                timeToMinutes("6:57"),
                timeToMinutes("6:35"),
                timeToMinutes("7:02"),
                timeToMinutes("7:30"),
                timeToMinutes("6:15"),
                timeToMinutes("6:45"),
                timeToMinutes("7:03")],
              tension: 0.1
            }
          ]
        },
        options: {
          maintainAspectRatio: false,
          responsive: true,
          plugins: {
            title: {
              display: false,
              text: "Clocked Hours",
              color: "white",
            },
            legend: {
              labels: {
                color: "white"
              },
              align: "end",
              position: "bottom"
            },
            tooltip: {
              mode: "index",
              intersect: false
            },
            hover: {
              mode: "nearest",
              intersect: true
            }
          },
          scales: {
            x: {
              ticks: {
                color: "rgba(255,255,255,0.7)"
              },
              display: true,
              title: {
                display: false,
                text: "Day",
                color: "white"
              },
              grid: {
                display: false,
                borderDash: [2],
                borderDashOffset: [2],
                color: "rgba(33, 37, 41, 0.3)",
                zeroLineColor: "rgba(0, 0, 0, 0)",
                zeroLineBorderDash: [2],
                zeroLineBorderDashOffset: [2]
              }
            },
            y: {
              ticks: {
                color: "rgba(255,255,255,0.7)",
                // Callback to format y-axis labels as "HH:MM"
                callback: (value) => {
                  return minutesToTime(value);
                },
                stepSize: 60, // One-hour increments
                // Optional: Force stepSize by setting maxTicksLimit if needed
                // maxTicksLimit: 13 // 0 to 12 inclusive
              },
              display: true,
              title: {
                display: false,
                text: "Time",
                color: "white"
              },
              grid: {
                borderDash: [3],
                borderDashOffset: [3],
                drawBorder: false,
                color: "rgba(255, 255, 255, 0.15)",
                zeroLineColor: "rgba(33, 37, 41, 0)",
                zeroLineBorderDash: [2],
                zeroLineBorderDashOffset: [2]
              },
              beginAtZero: true // Ensures y-axis starts at zero
            }
          }
        }
      };

      // Access the <canvas> element via ref and get its 2D context
      const ctx = this.$refs.lineChart.getContext("2d");

      // Initialize the Chart instance
      new Chart(ctx, config);
    });
  }
};
</script>

<template>
  <div class="w-full xl:w-8/12 mb-12 xl:mb-0 px-4">
    <div class="relative flex flex-col min-w-0 break-words w-full mb-6 shadow-lg rounded bg-blueGray-800">
      <div class="rounded-t mb-0 px-4 py-3 bg-transparent">
        <div class="flex flex-wrap items-center">
          <div class="relative w-full max-w-full flex-grow flex-1">
            <h6 class="uppercase text-blueGray-100 mb-1 text-xs font-semibold">
              Overview
            </h6>
            <h2 class="text-white text-xl font-semibold">
              Clocked Hours
            </h2>
          </div>
        </div>
      </div>
      <div class="p-4 flex-auto">
        <!-- Chart -->
        <div class="relative" style="height:350px">
          <canvas ref="lineChart"></canvas>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.chart-container {
  position: relative;
  height: 350px; /* Ensures the canvas has a defined height */
}
</style>
