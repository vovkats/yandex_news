export default class ShowUntilValidator {
    static error = "Время актуальности новости должно быть заполнено и быть больше текущего времени";

    static validate(vueState, time) {
        if (+time < +new Date()) {
            vueState.$data.news.errors.push(ShowUntilValidator.error);
            return false;
        } else {
            vueState.$data.news.errors = vueState.$data.news.errors.filter((error) => {
                return error !== ShowUntilValidator.error;
            });

            return true;
        }
    }
}