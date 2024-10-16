<script>
import NavbarComponent from "../components/Navbar.vue";
import FooterComponent from "../components/Footer.vue";
import backgroundImage from '../assets/img/register_bg_2.png';
import githubIcon from '../assets/img/github.svg';
import googleIcon from '../assets/img/google.svg';
import axios from 'axios';
import Notification from './Notification.vue';
import { ref, reactive } from 'vue';


export default {
  name: "login-page",
  components: {
    NavbarComponent,
    FooterComponent
  },
  data() {
    return {
      backgroundImage,
      githubIcon,
      googleIcon
    };
  },
  setup(props, { emit }) { // `emit` est disponible dans le deuxième argument de `setup`
    const username = ref('');
    const email = ref('');
    const firstName = ref('');
    const lastName = ref('');
    const password = ref('');
    const contactNumber = ref('');

    const userData = ref(null);
    const loading = ref(false);
    const notifications = reactive([]);

    const addNotification = (message) => {
      notifications.push({ id: Date.now(), message });
    };

    const createUser = async () => {
      loading.value = true;
      try {
        const response = await axios.post('http://127.0.0.1:4000/api/users', {
          user: {
            username: username.value,
            email: email.value,
            firstname: firstName.value,
            lastname: lastName.value,
            password: password.value,
            contact_number: contactNumber.value,
            role_id: 1,
            team_id: null,
            manager_id: null
          },
        });
        userData.value = response.data;
        addNotification('User created successfully.');
        // Switch to edit mode with the new user's data
      } catch (error) {
        handleError(error, 'An error occurred while creating the user.');
        console.error('Error creating user:', error);
      } finally {
        loading.value = false;
      }
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

    const switchToLogin = () => {
      emit('switchToLogin');
    };

    return {
      username,
      email,
      firstName,
      lastName,
      password,
      contactNumber,
      userData,
      loading,
      notifications,
      createUser, // Retourné pour être utilisé dans le template
      addNotification,
      switchToLogin // Retourné pour être utilisé dans le template
    };
  }
};
</script>

<template>
  <div>
    <navbar-component></navbar-component>
    <main>
      <section class="absolute w-full h-full">
        <div
          class="absolute top-0 w-full h-full bg-gray-900"
          style="background-size: 100%; background-repeat: no-repeat;"
          :style="{ 'background-image': `url(${backgroundImage})` }"
        ></div>
        <div class="container mx-auto px-4 h-full">
          <div class="flex content-center items-center justify-center h-full">
            <div class="w-full lg:w-4/12 px-4">
              <div class="relative flex flex-col min-w-0 break-words w-full mb-6 shadow-lg rounded-lg bg-gray-300 border-0">
                <div class="mt-6 flex-auto px-4 lg:px-10 py-10 pt-0">
                  <div class="text-gray-500 text-center mb-3 font-bold">
                    <h6 class="text-gray-600 text-sm font-bold">
                      Sign in with
                    </h6>
                  </div>
                  <form>
                    <!-- Username Field -->
                    <div class="relative w-full mb-3">
                      <label
                        class="block uppercase text-gray-700 text-xs font-bold mb-2"
                        for="username"
                        >Username</label
                      ><input
                        v-model="username"
                        type="username"
                        id="username"
                        class="border-0 px-3 py-3 placeholder-gray-400 text-gray-700 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full"
                        placeholder="username"
                        style="transition: all 0.15s ease 0s;"
                      />
                    </div>

                    <!-- Email Field -->
                    <div class="relative w-full mb-3">
                      <label
                        class="block uppercase text-gray-700 text-xs font-bold mb-2"
                        for="email"
                        >Email</label
                      ><input
                        v-model="email"
                        type="email"
                        id="email"
                        class="border-0 px-3 py-3 placeholder-gray-400 text-gray-700 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full"
                        placeholder="Enter your email"
                        style="transition: all 0.15s ease 0s;"
                      />
                    </div>

                    <!-- First Name Field -->
                    <div class="relative w-full mb-3">
                      <label
                        class="block uppercase text-gray-700 text-xs font-bold mb-2"
                        for="firstname"
                        >First Name</label
                      ><input
                        v-model="firstName"
                        type="text"
                        id="firstname"
                        class="border-0 px-3 py-3 placeholder-gray-400 text-gray-700 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full"
                        placeholder="Enter your first name"
                        style="transition: all 0.15s ease 0s;"
                      />
                    </div>

                    <!-- Last Name Field -->
                    <div class="relative w-full mb-3">
                      <label
                        class="block uppercase text-gray-700 text-xs font-bold mb-2"
                        for="lastname"
                        >Last Name</label
                      ><input
                        v-model="lastName"
                        type="text"
                        id="lastname"
                        class="border-0 px-3 py-3 placeholder-gray-400 text-gray-700 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full"
                        placeholder="Enter your last name"
                        style="transition: all 0.15s ease 0s;"
                      />
                    </div>


                    <!-- Password Field -->
                    <div class="relative w-full mb-3">
                      <label
                      class="block uppercase text-gray-700 text-xs font-bold mb-2"
                      for="password"
                      >Password</label
                      ><input
                      v-model="password"
                      type="password"
                      id="password"
                      class="border-0 px-3 py-3 placeholder-gray-400 text-gray-700 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full"
                      placeholder="Password"
                      style="transition: all 0.15s ease 0s;"
                      />
                    </div>

                    <!-- Contact Number Field -->
                    <div class="relative w-full mb-3">
                      <label
                        class="block uppercase text-gray-700 text-xs font-bold mb-2"
                        for="contact_number"
                        >Contact Number</label
                      ><input
                        v-model="contactNumber"
                        type="tel"
                        id="contact_number"
                        class="border-0 px-3 py-3 placeholder-gray-400 text-gray-700 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full"
                        placeholder="Enter your contact number"
                        style="transition: all 0.15s ease 0s;"
                      />
                    </div>

                    <!-- Submit Button -->
                    <div class="text-center mt-6">
                      <button
                        @click.prevent="createUser"
                        class="bg-gray-900 text-white active:bg-gray-700 text-sm font-bold uppercase px-6 py-3 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 w-full"
                        type="submit"
                        style="transition: all 0.15s ease 0s;"
                      >
                        Sign Up
                      </button>

                      <!-- Already have an account? -->
                      <p class="mt-4 text-center text-sm text-gray-600">
                        Already have an account?
                        <a href="#" @click.prevent="switchToLogin" class="text-indigo-500 hover:text-indigo-700 font-medium">Login</a>
                      </p>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- Render notifications dynamically -->
        <Notification
                      v-for="notification in notifications"
                      :key="notification.id"
                      :message="notification.message"
                    />
        <footer-component></footer-component>
      </section>
    </main>
  </div>
</template>
