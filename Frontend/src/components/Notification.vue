<template>
  <div
    v-if="visible"
    class="fixed bottom-5 right-5 w-72 bg-gray-800 text-white p-4 rounded-lg shadow-lg flex justify-between items-center z-50"
  >
    <span>{{ message }}</span>
    <button
      @click="close"
      class="text-white text-xl cursor-pointer hover:text-red-500"
    >
      &times;
    </button>
  </div>
</template>

<script>
export default {
  props: {
    message: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      visible: true,
    };
  },
  methods: {
    close() {
      this.visible = false;
    },
  },
  mounted() {
    // Auto-close after 5 seconds
    setTimeout(() => {
      this.visible = false;
    }, 2000);
  },
};
</script>

<style scoped>
/* Scoped styles are not needed since Tailwind CSS is used */
</style>
