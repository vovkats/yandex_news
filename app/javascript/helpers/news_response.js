import strftime from 'strftime';

export default class NewsResponse {

    static check(vueState, responseData) {
        if (responseData["errors"].length > 0) {
            vueState.$data.sendFault = true;
            vueState.$data.sendData = false;
        } else {
            vueState.$data.sendData = true;
            vueState.$data.sendFault = false;
        }
    }

    static initData(vueState, news) {
        vueState.$data.news.title = news["title"];
        vueState.$data.news.description = news["description"];
        vueState.$data.news.id = news["id"];
        if (news["show_until"]) {
            vueState.$data.news.time = strftime('%H:%M', new Date(news["show_until"]));
            vueState.$data.news.date = strftime('%F', new Date(news["show_until"]));
        } else {
            let currentTime = new Date();
            vueState.$data.news.time = strftime('%H:%M', currentTime);
            vueState.$data.news.date = strftime('%F', currentTime);
        }
    }
}