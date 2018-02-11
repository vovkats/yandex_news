<template>
  <div id="app">
    <v-app>
      <v-content>
        <v-alert color="success" icon="check_circle" value="true">
          {{ message }}
        </v-alert>
      </v-content>
    </v-app>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello!"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
