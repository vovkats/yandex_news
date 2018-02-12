<template lang="pug">
  v-app
    authors-form
</template>

<script>

  import AuthorsForm from './authors-form.vue'

  export default {
    components: { AuthorsForm }
  }
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
