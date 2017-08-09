import riot from 'riot'
import 'whatwg-fetch'
import './tags/current-rates.tag'
import './tags/select.tag'


var currentRatesCallback = function(currentRatesTag, base = 'GBP') {
  var url = location.protocol + '//' + location.host + '/api/oanda/' + base;
  fetch(url).then(function(response) {
    return response.json();
  }).then(function(data) {
    currentRatesTag.trigger('data_loaded', data);
  })
}

riot.mount('current-rates', {callback:currentRatesCallback})
