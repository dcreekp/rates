import requests
import arrow
from decimal import Decimal, getcontext
from .utils import OPENX_CURRENCIES


class Openx(object):

    DEFAULT_BASE = 'USD'
    APP_ID = '7f7b54e590004181abf46b48f766bacb'
    NAMES = OPENX_CURRENCIES

    LATEST = 'https://openexchangerates.org/api/latest.json'
    CURRENCY_LIST = 'https://openexchangerates.org/api/currencies.json'

    def __init__(self, base):
        self.base = base.upper()
        self.rates = self.api_latest().json()['rates']
        self.inverse = self._invert_base(self.rates[self.base])

    def collect_quotes(self):
        data = {}
        for symbol, rate in self._convert_rates():
            data[symbol] = {
                'rate': rate,
                'name': self.NAMES[symbol]
                }
        data[self.base]['rate'] = '1'
        return data

    def _convert_rates(self):
        if self.base != self.DEFAULT_BASE:
            for symbol, rate in self.rates.items():
                yield symbol, self._convert(rate, self.inverse)
        else:
            for symbol, rate in self.rates.items():
                yield symbol, self._convert_default(rate)

    def _invert_base(self, base):
        getcontext().prec = 6
        return 1 / Decimal(base)

    def _convert(self, a, decimal_b):
        getcontext().prec = 6
        return str(Decimal(a) * decimal_b)

    def _convert_default(self, a):
        getcontext().prec = 6
        return str(Decimal(a) * Decimal(1))

    def api_currency_list(self):
        params = {'app_id': self.APP_ID}
        return requests.get(self.CURRENCY_LIST, params=params)

    def api_latest(self):
        params = {'app_id': self.APP_ID, 'base': self.DEFAULT_BASE}
        return requests.get(self.LATEST, params=params)


class Oanda(object):

    INST = [
        'EUR_DKK', 'EUR_PLN', 'EUR_AUD', 'TRY_JPY', 'NZD_HKD', 'GBP_NZD',
        'USD_CZK', 'USD_NOK', 'EUR_GBP', 'EUR_JPY', 'NZD_CHF', 'CAD_CHF',
        'SGD_JPY', 'EUR_HKD', 'USD_HKD', 'USD_DKK', 'ZAR_JPY', 'AUD_NZD',
        'GBP_AUD', 'USD_PLN', 'NZD_CAD', 'AUD_USD', 'EUR_CAD', 'NZD_JPY',
        'EUR_NZD', 'GBP_PLN', 'AUD_HKD', 'GBP_HKD', 'GBP_SGD', 'USD_SEK',
        'AUD_CAD', 'CAD_SGD', 'USD_CHF', 'USD_CAD', 'EUR_HUF', 'HKD_JPY',
        'CHF_JPY', 'SGD_HKD', 'CHF_HKD', 'USD_INR', 'AUD_CHF', 'EUR_SGD',
        'USD_SGD', 'EUR_SEK', 'GBP_CHF', 'USD_THB', 'NZD_USD', 'CHF_ZAR',
        'USD_JPY', 'EUR_TRY', 'CAD_JPY', 'NZD_SGD', 'CAD_HKD', 'EUR_NOK',
        'GBP_ZAR', 'USD_SAR', 'GBP_CAD', 'USD_HUF', 'GBP_USD', 'USD_MXN',
        'AUD_JPY', 'EUR_USD', 'EUR_ZAR', 'EUR_CZK', 'SGD_CHF', 'USD_ZAR',
        'GBP_JPY', 'USD_TRY', 'EUR_CHF', 'USD_CNH', 'AUD_SGD'
        ]

    NAMES = {
        'USD': 'U.S. Dollar',
        'EUR': 'Euro',
        'JPY': 'Japanese Yen',
        'GBP': 'British Pound Sterling',
        'AUD': 'Australian Dollar',
        'CAD': 'Canadian Dollar',
        'CHF': 'Swiss Franc',
        'CNH': 'Chinese Yuan Renminbi',
        'CZK': 'Czech Koruna',
        'DKK': 'Danish Krone',
        'HKD': 'Hong Kong Dollar',
        'HUF': 'Hungarian Forint',
        'INR': 'Indian Rupee',
        'MXN': 'Mexican Peso',
        'NOK': 'Norwegian Krone',
        'NZD': 'New Zealand Dollar',
        'PLN': 'Polish Zloty',
        'SAR': 'Saudi Riyal',
        'SEK': 'Swedish Krona',
        'SGD': 'Singapore Dollar',
        'THB': 'Thai Baht',
        'TRY': 'Turkish Lira',
        'ZAR': 'South African Rand'
        }

    HEADER = {
        'Authorization': 'Bearer 3fbdb2383e02afc35003548414b31f4e-d8d49cf78973a39c270f3576780f0260'
        }

    URL = 'https://api-fxpractice.oanda.com/v3/accounts/%s/pricing'

    ACCOUNT_ID = '101-004-6233194-001'

    def __init__(self, base):
        self.base = base.upper()
        self.instruments = [i for i in self.INST if self.base in i]
        self.quotes = self.collect_quotes()
        self.bases = self.collect_bases()

    def collect_quotes(self):
        data = {
            self.base: {
                'rate': 1,
                'name': self.NAMES[self.base]
                }
            }
        for symbol, rate in self.parse_rates(self.api_instruments()):
            data[symbol] = {
                'rate': rate,
                'name': self.NAMES[symbol]
                }
        return data

    def collect_bases(self):
        return [{
            'symbol': symbol,
            'name': name
            } for symbol, name in self.NAMES.items()
        ]

    def api_instruments(self):
        params = {'instruments': ','.join(self.instruments)}
        url = self.URL % self.ACCOUNT_ID
        return requests.get(url, headers=self.HEADER, params=params)

    def parse_rates(self, response):
        prices = response.json()['prices']
        for i in prices:
            base, quote = i['instrument'].split('_')
            if base == self.base:
                yield (quote,
                       str(self.base_rate(i['closeoutBid'], i['closeoutAsk']))
                )
            else:
                yield (base,
                       str(self.quote_rate(i['closeoutBid'], i['closeoutAsk']))
                )

    def base_rate(self, bid, ask):
        bid, ask = Decimal(bid), Decimal(ask)
        getcontext().prec = 6
        mid_market = (bid + ask) / 2
        return mid_market

    def quote_rate(self, bid, ask):
        mid_market = self.base_rate(bid, ask)
        getcontext().prec = 6
        inverse = 1 / mid_market
        return inverse

