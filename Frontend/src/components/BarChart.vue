<script>

import {
  Chart,
  BarController,
  BarElement,
  CategoryScale,
  LinearScale,
  Title,
  Tooltip,
  Legend
} from 'chart.js';

Chart.register(
  BarController,
  BarElement,
  CategoryScale,
  LinearScale,
  Title,
  Tooltip,
  Legend
);

export default {
  name: "BarChart",
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
      const config = {
        type: "bar",
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
                timeToMinutes("7:00"),
              ],
              fill: false,
              barThickness: 8 // Adds slight curve to the line
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
                timeToMinutes("7:03")
              ],
              barThickness: 8
            }
          ]
        },
        options: {
          maintainAspectRatio: false,
          responsive: true,
          plugins: {
            title: {
              display: false,
              text: "Orders Chart"
            },
            tooltip: {
              mode: "index",
              intersect: false
            },
            hover: {
              mode: "nearest",
              intersect: true
            },
            legend: {
              labels: {
                color: "rgba(0,0,0,.4)"
              },
              align: "end",
              position: "bottom"
            }
          },
          scales: {
            x: {
              display: false,
              title: {
                display: true,
                text: "Day"
              },
              grid: {
                borderDash: [2],
                borderDashOffset: [2],
                color: "rgba(33, 37, 41, 0.3)",
                zeroLineColor: "rgba(33, 37, 41, 0.3)",
                zeroLineBorderDash: [2],
                zeroLineBorderDashOffset: [2]
              }
            },
            y: {
              display: true,
              title: {
                display: false,
                text: "Hours"
              },
              grid: {
                borderDash: [2],
                drawBorder: false,
                borderDashOffset: [2],
                color: "rgba(33, 37, 41, 0.2)",
                zeroLineColor: "rgba(33, 37, 41, 0.15)",
                zeroLineBorderDash: [2],
                zeroLineBorderDashOffset: [2]
              },
              // Configure the y-axis to display time
              min: 0, // Start at 0 minutes (0:00)
              max: 720, // End at 1440 minutes (24:00)
              ticks: {
                stepSize: 60, // 1-hour increments
                callback: (value) => {
                  return minutesToTime(value);
                },
                color: "rgba(0,0,0,0.7)" // Darker color for better visibility
              },
              // Optionally, you can set the scale type to 'linear' explicitly
              type: 'linear',
              beginAtZero: true
            }
          }
        }
      };
      const ctx = this.$refs.barChart.getContext("2d");
      new Chart(ctx, config);
    });
  }
};
</script>

<template>
  <div class="w-full xl:w-4/12 px-4">
    <div class="relative flex flex-col min-w-0 break-words bg-white w-full mb-6 shadow-lg rounded">
      <div class="rounded-t mb-0 px-4 py-3 bg-transparent">
        <div class="flex flex-wrap items-center">
          <div class="relative w-full max-w-full flex-grow flex-1">
            <h6 class="uppercase text-blueGray-400 mb-1 text-xs font-semibold">
              Timelog
            </h6>
            <h2 class="text-blueGray-700 text-xl font-semibold">
              Schedule accuracy
            </h2>
          </div>
        </div>
      </div>
      <div class="p-4 flex-auto">
        <!-- Chart -->
        <div class="relative" style="height:350px">
          <canvas ref="barChart"></canvas>
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
