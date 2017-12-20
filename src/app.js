import riot from 'riot'
import route from 'riot-route'
//import moment from 'moment-timezone'
import 'whatwg-fetch'
import './css/blaze.min.css'
import './tags/current-rates.tag'
import './tags/select.tag'
import './tags/display.tag'


var currentRatesCallback = (tag, base, quote = null, amount = null) => {
  let url = location.protocol + '//' + location.host + '/api/xnepo/' + base;
  fetch(url).then((response) => {
    return response.json();
  }).then((data) => {
    data.data.quote = quote
    data.data.amount = amount
    tag.trigger('data_loaded', data);
  })
  return tag
}

var currentRates = null

// defining the routes
// it will either mount the current-rates tag or reload it with new data
// or unmount the tag depending on the information in the url
route((base, quote, amount) => {
  if (currentRates) {
    currentRates = currentRatesCallback(currentRates, base, quote, amount)
  } else if (!currentRates && base) {
    currentRates = riot.mount(
      'current-rates',
      {callback:currentRatesCallback, base:base, quote:quote, amount:amount}
      )[0]
  } else if (base === '' && currentRates !== null) {
    currentRates.unmount(true)
    currentRates = null
  }
})

//route.base('/')
route.start(true)
