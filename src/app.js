import riot from 'riot'
import route from 'riot-route'
import moment from 'moment-timezone'
import 'whatwg-fetch'
import './css/blaze.min.css'
import './tags/current-rates.tag'
import './tags/select.tag'


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

var currentRatesCallback = (tag, base, quote = null) => {
  let url = location.protocol + '//' + location.host + '/api/oanda/' + base;
  fetch(url).then((response) => {
    return response.json();
  }).then((data) => {
    data.data.bases = bases
    data.data.quote = quote
    tag.trigger('data_loaded', data);
  })
  return tag
}

var currentRates = null

route((base) => {
  //console.log('in base')
  if (base.length === 3) {
    if (currentRates) {
      currentRates = currentRatesCallback(currentRates, base)
    } else {
      currentRates = riot.mount(
        'current-rates',
        {callback:currentRatesCallback, base:base}
        )[0]
    }
  } else if (base === '' && currentRates !== null) {
    currentRates.unmount(true)
    currentRates = null
  }
})

route((base, quote) => {
  //console.log('in base quote', currentRates.opts.base)
  if (quote === null) {
    route(base)
  } else if (currentRates) {
    currentRates = currentRatesCallback(currentRates, base, quote)
  } else if (!currentRates) {
    currentRates = riot.mount(
      'current-rates',
      {callback:currentRatesCallback, base:base, quote:quote}
      )[0]
  }
})

//route.base('/')
route.start(true)
