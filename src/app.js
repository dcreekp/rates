import riot from 'riot'
import moment from 'moment-timezone'
import 'whatwg-fetch'
import './css/blaze.min.css'
import './tags/current-rates.tag'
import './tags/select.tag'


var currentRatesCallback = (currentRatesTag, base = 'GBP') => {
  let url = location.protocol + '//' + location.host + '/api/oanda/' + base;
  fetch(url).then((response) => {
    return response.json();
  }).then((data) => {
    currentRatesTag.trigger('data_loaded', data);
  })
}

riot.mount('current-rates', {callback:currentRatesCallback})
