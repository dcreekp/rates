import riot from 'riot'
import route from 'riot-route'
import moment from 'moment-timezone'
import 'whatwg-fetch'
import './css/blaze.min.css'
import './tags/current-rates.tag'
import './tags/select.tag'


var currentRatesCallback = (tag, base) => {
  let url = location.protocol + '//' + location.host + '/api/oanda/' + base;
  fetch(url).then((response) => {
    return response.json();
  }).then((data) => {
    tag.trigger('data_loaded', data);
  })
  return tag
}

var currentRates = null

route((path) => {
  if (path.length === 3) {
    if (currentRates) {
      currentRates = currentRatesCallback(currentRates, path)
    } else {
      currentRates = riot.mount(
        'current-rates',
        {callback:currentRatesCallback, base:path}
        )[0]
    }
  }
})

route.base('/')
route.start(true)
