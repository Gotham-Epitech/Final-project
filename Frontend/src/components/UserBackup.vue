<script setup>
import { ref, reactive } from 'vue';
import axios from 'axios';
import Notification from './Notification.vue';
import { useRouter } from 'vue-router';

const searchUsername = ref('');
const searchEmail = ref('');
const editUsername = ref('');
const editEmail = ref('');
const userData = ref(null);
const loading = ref(false);
const notifications = reactive([]);
const isEditing = ref(false);

const addNotification = (message) => {
  notifications.push({ id: Date.now(), message });
};

const createUser = async () => {
  loading.value = true;
  try {
    const response = await axios.post('http://127.0.0.1:4000/api/users', {
      user: {
        username: searchUsername.value,
        email: searchEmail.value,
      },
    });
    userData.value = response.data;
    addNotification('User created successfully.');
    // Switch to edit mode with the new user's data
    enterEditMode(userData.value);
  } catch (error) {
    handleError(error, 'An error occurred while creating the user.');
    console.error('Error creating user:', error);
  } finally {
    loading.value = false;
  }
};

const updateUser = async () => {
  if (!userData.value) return;
  loading.value = true;
  try {
    const response = await axios.put(
      `http://127.0.0.1:4000/api/users/${userData.value.id}`,
      {
        user: {
          username: editUsername.value,
          email: editEmail.value,
        },
      }
    );
    userData.value = response.data;
    addNotification('User updated successfully.');
    // Update edit fields with the latest data
    editUsername.value = userData.value.username;
    editEmail.value = userData.value.email;
  } catch (error) {
    handleError(error, 'An error occurred while updating the user.');
    console.error('Error updating user:', error);
  } finally {
    loading.value = false;
  }
};

const getUser = async () => {
  loading.value = true;
  try {
    const response = await axios.get('http://127.0.0.1:4000/api/users', {
      params: {
        username: searchUsername.value,
        email: searchEmail.value,
      },
    });
    if (response.data.length > 0) {
      userData.value = response.data[0];
      addNotification('User found.');
      // Enter edit mode with the found user's data
      enterEditMode(userData.value);
    } else {
      userData.value = null;
      addNotification('No user found with the given credentials.');
    }
  } catch (error) {
    handleError(error, 'An error occurred while fetching the user.');
    console.error('Error getting user:', error);
  } finally {
    loading.value = false;
  }
};

const deleteUser = async () => {
  if (!userData.value) return;
  loading.value = true;
  try {
    await axios.delete(`http://127.0.0.1:4000/api/users/${userData.value.id}`);
    addNotification('User deleted successfully.');
    // Reset states after deletion
    exitEditMode();
  } catch (error) {
    handleError(error, 'An error occurred while deleting the user.');
    console.error('Error deleting user:', error);
  } finally {
    loading.value = false;
  }
};

const enterEditMode = (user) => {
  isEditing.value = true;
  editUsername.value = user.username;
  editEmail.value = user.email;
};

const exitEditMode = () => {
  isEditing.value = false;
  userData.value = null;
  editUsername.value = '';
  editEmail.value = '';
  searchUsername.value = '';
  searchEmail.value = '';
};

const handleError = (error, defaultMessage) => {
  if (error.response && error.response.data && error.response.data.errors) {
    const errors = error.response.data.errors;
    if (errors.username) {
      addNotification(`Username error: ${errors.username.join(', ')}`);
    }
    if (errors.email) {
      addNotification(`Email error: ${errors.email.join(', ')}`);
    }
  } else {
    addNotification(defaultMessage);
  }
};
</script>

<template>
  <div class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-white p-6 rounded-lg shadow-lg w-full max-w-md">
      <h1 class="text-2xl font-semibold mb-4 text-center text-black">Gotham Time Manager</h1>

      <div v-if="loading" class="text-center text-gray-500">Loading...</div>

      <div v-else>
        <!-- Search Form -->
        <div v-if="!isEditing">
          <div class="mb-4">
            <label class="block text-gray-700">Username:</label>
            <input
              v-model="searchUsername"
              type="text"
              class="w-full mt-1 p-2 border border-gray-300 rounded text-black"
              placeholder="Enter username"
            />
          </div>
          <div class="mb-4">
            <label class="block text-gray-700">Email:</label>
            <input
              v-model="searchEmail"
              type="email"
              class="w-full mt-1 p-2 border border-gray-300 rounded text-black"
              placeholder="Enter email"
            />
          </div>
          <div class="flex justify-between">
            <button
              @click="getUser"
              class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
            >
              Check Employee
            </button>
            <button
              @click="createUser"
              class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"
            >
              Create Employee
            </button>
          </div>
        </div>

        <!-- Edit Form -->
        <div v-else>
          <div class="mb-4">
            <label class="block text-gray-700">Username:</label>
            <input
              v-model="editUsername"
              type="text"
              class="w-full mt-1 p-2 border border-gray-300 rounded text-black"
            />
          </div>
          <div class="mb-4">
            <label class="block text-gray-700">Email:</label>
            <input
              v-model="editEmail"
              type="email"
              class="w-full mt-1 p-2 border border-gray-300 rounded text-black"
            />
          </div>
          <div class="flex justify-between">
            <button
              @click="updateUser"
              class="bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600"
            >
              Save Changes
            </button>
            <button
              @click="deleteUser"
              class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600"
            >
              Delete Employee
            </button>
          </div>
          <button
            @click="exitEditMode"
            class="mt-4 bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 w-full"
          >
            Back to Search
          </button>
          <!-- Navigate to Working Times -->
          <button
            @click="() => router.push(`/users/${userData.id}/workingtimes`)"
            class="bg-purple-500 text-white px-4 py-2 rounded hover:bg-purple-600"
          >
            Manage Working Times
          </button>
        </div>
      </div>
    </div>

    <!-- Render notifications dynamically -->
    <Notification
      v-for="notification in notifications"
      :key="notification.id"
      :message="notification.message"
    />
  </div>
</template>

<style scoped>
/* No additional styles needed as Tailwind CSS is used */
</style>
