<template>
  <v-flex xs11 lg6 offset-sm1>
     <v-form v-model="valid" ref="form" lazy-validation>
        <v-alert outline
                color="success"
                icon="check_circle"
                v-model="sendData"
                transition="scale-transition"
                dismissible>
          Данные обновлены
        </v-alert>
        <v-alert outline
                color="error"
                icon="check_circle"
                v-model="sendFault"
                transition="scale-transition"
                dismissible>
          Проверьте данные
        </v-alert>

        <v-text-field
                label="Заголовок"
                v-model="news.title"
                :rules="commonRules"
                :counter="100"
                prepend-icon="title"
                required>
        </v-text-field>

        <v-text-field
                label="Описание"
                v-model="news.description"
                :rules="commonRules"
                prepend-icon="description"
                required
                textarea>
        </v-text-field>

        <v-menu lazy
                v-model="menuDate"
                transition="scale-transition"
                offset-y
                full-width
                :nudge-right="40"
                max-width="290px"
                min-width="290px">
            <v-text-field
                    slot="activator"
                    label="Дата"
                    v-model="news.date"
                    prepend-icon="date_range"
                    required
                    readonly>
            </v-text-field>
            <v-date-picker locale="ru-Latn" v-model="news.date"></v-date-picker>
        </v-menu>

        <v-menu :close-on-content-click="false"
                lazy
                v-model="menuTime"
                transition="scale-transition"
                offset-y
                full-width
                :nudge-right="40"
                max-width="290px"
                min-width="290px">
            <v-text-field slot="activator"
                    label="Время"
                    v-model="news.time"
                    prepend-icon="access_time"
                    required
                    readonly>
            </v-text-field>
            <v-time-picker v-model="news.time" autosave format="24hr"></v-time-picker>
        </v-menu>

        <v-btn @click="submit" :disabled="!valid">
            <span v-if="persistedNews">
                Редактировать
            </span>
            <span v-else>
                Создать
            </span>
        </v-btn>
     </v-form>
  </v-flex>
</template>

<script>
    import axios from 'axios'
    import strftime from 'strftime'

    export default {
        data: function () {
            return {
                valid: true,
                commonRules: [
                    (v) => !!v || 'Поле обязательное для заполнения',
                    (v) => v && v.length <= 1000 || 'Должно быть не более 100 символов'
                ],
                news: {
                    id: null,
                    date: null,
                    time: null,
                    title: null,
                    description: null
                },
                menuDate: null,
                menuTime: null,
                sendData: false,
                sendFault: false
            }
        },
        mounted: function () {
            let self = this;
            axios.get('/news')
            .then((response) => {
                let news = response.data["data"];
                self.$data.news.title = news["title"];
                self.$data.news.description = news["description"];
                self.$data.news.id = news["id"];
                if (news["show_until"]) {
                    self.$data.news.time = strftime('%H:%M', new Date(news["show_until"]));
                    self.$data.news.date = strftime('%F', new Date(news["show_until"]));
                }

            })
            .catch(function (error) {
                console.log(error);
            });
        },
        methods: {
            submit() {
                let newsData = this.$data.news;
                let newsParams = {
                    title: newsData.title,
                    description: newsData.description,
                    time: parseInt(new Date().getTime() / 1000),
                    show_until: new Date(`${this.$data.news.date} ${this.$data.news.time}`)
                };

                if (this.$refs.form.validate()) {
                    if (this.persistedNews) {
                        axios.patch('/news', { news: newsParams }).then((response) => {
                            this.$data.sendData = true;
                        })
                    } else {
                        axios.post('/news', { news: newsParams }).then((response) => {
                            this.$data.sendData = true;
                        })
                    }
                } else {
                    this.$data.sendFault = true
                }
            }
        },
        computed: {
            persistedNews: function () {
                return !!this.$data.news.id;
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
