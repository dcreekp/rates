import riot from 'riot'
import route from 'riot-route'
import moment from 'moment-timezone'
import 'whatwg-fetch'
import './css/blaze.min.css'
import './tags/current-rates.tag'
import './tags/select.tag'
import './tags/display.tag'


const bases = [
  {'symbol':'USD', 'name':'U.S. Dollar'},
  {'symbol':'EUR', 'name':'Euro'},
  {'symbol':'JPY', 'name':'Japanese Yen'},
  {'symbol':'GBP', 'name':'British Pound Sterling'},
  {'symbol':'AUD', 'name':'Australian Dollar'},
  {'symbol':'CAD', 'name':'Canadian Dollar'},
  {'symbol':'CHF', 'name':'Swiss Franc'},
  {'symbol':'CNH', 'name':'Chinese Yuan Renminbi'},
  {'symbol':'CZK', 'name':'Czech Koruna'},
  {'symbol':'DKK', 'name':'Danish Krone'},
  {'symbol':'HKD', 'name':'Hong Kong Dollar'},
  {'symbol':'HUF', 'name':'Hungarian Forint'},
  {'symbol':'INR', 'name':'Indian Rupee'},
  {'symbol':'MXN', 'name':'Mexican Peso'},
  {'symbol':'NOK', 'name':'Norwegian Krone'},
  {'symbol':'NZD', 'name':'New Zealand Dollar'},
  {'symbol':'PLN', 'name':'Polish Zloty'},
  {'symbol':'SAR', 'name':'Saudi Riyal'},
  {'symbol':'SEK', 'name':'Swedish Krona'},
  {'symbol':'SGD', 'name':'Singapore Dollar'},
  {'symbol':'THB', 'name':'Thai Baht'},
  {'symbol':'TRY', 'name':'Turkish Lira'},
  {'symbol':'ZAR', 'name':'South African Rand'}
]

var currentRatesCallback = (tag, base, quote = null, amount = null) => {
  let url = location.protocol + '//' + location.host + '/api/oanda/' + base;
  fetch(url).then((response) => {
    return response.json();
  }).then((data) => {
    data.data.bases = bases
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
  } else if (!currentRates) {
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
