import riot from 'riot'
import moment from 'moment-timezone'
import 'whatwg-fetch'
import './tags/current-rates.tag'
import './tags/select.tag'

var zone = {
  'Europe/London': 'GBP',
  'Asia/Tokyo': 'JPY',
  'Australia/Sydney': 'AUD',
  'America/New_York': 'USD',
  'Europe/Zurich': 'CHF',
  'Europe/Berlin': 'EUR',
}

var currentRatesCallback = (currentRatesTag, base = 'USD') => {
  let url = location.protocol + '//' + location.host + '/api/oanda/' + base;
  fetch(url).then((response) => {
    return response.json();
  }).then((data) => {
    currentRatesTag.trigger('data_loaded', data);
  })
}

var tz = moment.tz.guess()
var currency = zone[tz]

riot.mount('current-rates', {callback:currentRatesCallback, currency:currency})
