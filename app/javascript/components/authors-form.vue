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

        <v-alert v-for="(error, index) in news.errors"
                 outline
                 color="error"
                 icon="check_circle"
                 transition="scale-transition"
                 v-model="news.errors[index]"
                 dismissible>
            {{error}}
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
            <v-date-picker locale="ru-Latn" v-model="news.date" :allowed-dates="allowedDates"></v-date-picker>
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
    import NewsResponse from '../helpers/news_response'
    import ShowUntilValidator from '../helpers/show_until_validator'

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
                    description: null,
                    errors: []
                },
                menuDate: null,
                menuTime: null,
                sendData: false,
                sendFault: false
            }
        },
        mounted: function () {
            axios.get('/news')
            .then((response) => {
                NewsResponse.initData(this, response.data["data"]);
            })
            .catch(function (error) {
                console.log(error);
            });
        },
        methods: {
            submit() {
                let newsData = this.$data.news;
                let showUntil = new Date(`${this.$data.news.date} ${this.$data.news.time}`);

                let formValid = this.$refs.form.validate();
                let showUntilValid = ShowUntilValidator.validate(this, showUntil);

                if (formValid && showUntilValid) {
                    this.$data.sendData = true;
                    this.$data.sendFault = false;
                } else {
                    this.$data.sendData = false;
                    this.$data.sendFault = true;
                    return false;
                }

                let newsParams = {
                    title: newsData.title,
                    description: newsData.description,
                    time: parseInt(new Date().getTime() / 1000),
                    show_until: showUntil
                };

                if (this.persistedNews) {
                    axios.patch('/news', { news: newsParams, authenticity_token: window._token }).then((response) => {
                        NewsResponse.check(this, response['data']);
                    })
                } else {
                    axios.post('/news', { news: newsParams, authenticity_token: window._token }).then((response) => {
                        NewsResponse.check(this, response['data']);
                        this.$data.news.id = response["data"]["data"]["id"];
                    })
                }
            },
            allowedDates: (val) => {
                let choosenDate = new Date(val).setHours(0, 0, 0, 0);
                let currentDate = new Date().setHours(0, 0, 0, 0);
                return choosenDate >= currentDate
            }
        },
        computed: {
            persistedNews: function () {
                return !!this.$data.news.id;
            }
        }
    }
</script>