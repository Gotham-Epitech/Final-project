<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { useRoute, useRouter } from 'vue-router';

const route = useRoute();
const router = useRouter();
const userId = ref(route.params.userid);
const workingTimeId = ref(route.params.workingtimeid);

const startTime = ref('');
const endTime = ref('');
const loading = ref(false);
const workingTimeData = ref(null);

const createWorkingTime = async () => {
  loading.value = true;
  try {
    await axios.post(`http://127.0.0.1:4000/api/workingtime/${userId.value}`, {
      start: startTime.value,
      end: endTime.value,
    });
    loading.value = false;
    router.push(`/workingTimes/${userId.value}`);
  } catch (error) {
    console.error('Error creating working time:', error);
    loading.value = false;
  }
};

const getWorkingTime = async () => {
  loading.value = true;
  try {
    const response = await axios.get(
      `http://127.0.0.1:4000/api/workingtime/${userId.value}/${workingTimeId.value}`
    );
    workingTimeData.value = response.data;
    startTime.value = workingTimeData.value.start;
    endTime.value = workingTimeData.value.end;
    loading.value = false;
  } catch (error) {
    console.error('Error fetching working time:', error);
    loading.value = false;
  }
};

const updateWorkingTime = async () => {
  loading.value = true;
  try {
    await axios.put(`http://127.0.0.1:4000/api/workingtime/${workingTimeId.value}`, {
      start: startTime.value,
      end: endTime.value,
    });
    loading.value = false;
    router.push(`/workingTimes/${userId.value}`);
  } catch (error) {
    console.error('Error updating working time:', error);
    loading.value = false;
  }
};

const deleteWorkingTime = async () => {
  loading.value = true;
  try {
    await axios.delete(`http://127.0.0.1:4000/api/workingtime/${workingTimeId.value}`);
    loading.value = false;
    router.push(`/workingTimes/${userId.value}`);
  } catch (error) {
    console.error('Error deleting working time:', error);
    loading.value = false;
  }
};

onMounted(() => {
  if (workingTimeId.value) {
    getWorkingTime();
  }
});
</script>

<template>
  <div class="max-w-md mx-auto p-4">
    <h2 class="text-xl font-semibold mb-4">
      {{ workingTimeId ? 'Edit' : 'Create' }} Working Time
    </h2>
    <div v-if="loading" class="text-gray-500">Loading...</div>
    <div v-else>
      <div class="mb-4">
        <label class="block text-gray-700">Start Time:</label>
        <input
          v-model="startTime"
          type="datetime-local"
          class="w-full mt-1 p-2 border border-gray-300 rounded"
        />
      </div>
      <div class="mb-4">
        <label class="block text-gray-700">End Time:</label>
        <input
          v-model="endTime"
          type="datetime-local"
          class="w-full mt-1 p-2 border border-gray-300 rounded"
        />
      </div>
      <div class="flex justify-between">
        <button
          v-if="!workingTimeId"
          @click="createWorkingTime"
          class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"
        >
          Create Working Time
        </button>
        <div v-else>
          <button
            @click="updateWorkingTime"
            class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
          >
            Update Working Time
          </button>
          <button
            @click="deleteWorkingTime"
            class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600 ml-2"
          >
            Delete Working Time
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Tailwind CSS handles styling */
</style>
