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
}