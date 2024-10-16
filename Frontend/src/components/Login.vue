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
    const searchUsername = ref('');
    const searchPassword = ref('');
    const userData = ref(null);
    const loading = ref(false);
    const notifications = reactive([]);

    const addNotification = (message) => {
      notifications.push({ id: Date.now(), message });
    };

    const getUser = async () => {
      loading.value = true;
      try {
        const response = await axios.get('http://127.0.0.1:4000/api/users', {
          params: {
            username: searchUsername.value,
            password: searchPassword.value,
          },
        });
        if (response.data.length > 0) {
          userData.value = response.data[0];
          console.log("user found")
          addNotification('User found.');
        } else {
          userData.value = null;
          addNotification('No user found with the given credentials.');
        }
      } catch (error) {
        handleError(error, 'An error occurred while fetching the user.');
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

    const switchToSignup = () => {
      emit('switchToSignup');
    };

    return {
      searchUsername,
      searchPassword,
      userData,
      loading,
      notifications,
      getUser,
      addNotification,
      switchToSignup // N'oublie pas de retourner `switchToSignup` pour l'utiliser dans le template
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
                        v-model="searchUsername"
                        type="username"
                        id="username"
                        class="border-0 px-3 py-3 placeholder-gray-400 text-gray-700 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full"
                        placeholder="username"
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
                        v-model="searchPassword"
                        type="password"
                        id="password"
                        class="border-0 px-3 py-3 placeholder-gray-400 text-gray-700 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full"
                        placeholder="Password"
                        style="transition: all 0.15s ease 0s;"
                      />
                    </div>

                    <!-- Remember me -->
                    <div>
                      <label class="inline-flex items-center cursor-pointer"
                        ><input
                          id="customCheckLogin"
                          type="checkbox"
                          class="form-checkbox border-0 rounded text-gray-800 ml-1 w-5 h-5"
                          style="transition: all 0.15s ease 0s;"
                        /><span class="ml-2 text-sm font-semibold text-gray-700"
                          >Remember me</span
                        ></label
                      >
                    </div>

                    <!-- Submit Button -->
                    <div class="text-center mt-6">
                      <button
                        @click.prevent="getUser"
                        class="bg-gray-900 text-white active:bg-gray-700 text-sm font-bold uppercase px-6 py-3 rounded shadow hover:shadow-lg outline-none focus:outline-none mr-1 mb-1 w-full"
                        type="button"
                        style="transition: all 0.15s ease 0s;"
                      >
                        Sign In
                      </button>

                      <!-- Additional Options -->
                      <p class="mt-4 text-center text-sm text-gray-600">
                        Don't have an account?
                        <a href="#" @click.prevent="switchToSignup" class="text-indigo-500 hover:text-indigo-700 font-medium">Sign up</a>
                      </p>
                    </div>
                  </form>
                </div>
              </div>
              <div class="flex flex-wrap mt-6">
                <div class="w-1/2">
                  <a href="#pablo" class="text-gray-300"
                    ><small>Forgot password?</small></a
                  >
                </div>
                <div class="w-1/2 text-right">
                  <a href="#pablo" class="text-gray-300"
                    ><small>Create new account</small></a
                  >
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
