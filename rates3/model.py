import requests
import arrow
from decimal import Decimal, getcontext


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
        self.rates = self.collect_rates()
        self.quotes = self.collect_symbols()

    def collect_rates(self):
        rates = {self.base: 1}
        for symbol, rate in self.parse_rates(self.api_instruments()):
            rates[symbol] = rate
        return rates

    def collect_symbols(self):
        return [
            {'text': ' - '.join([symbol, self.NAMES[symbol]])}
            for symbol in self.NAMES if symbol in self.rates
            ]

    def api_instruments(self):
        params = {'instruments': ','.join(self.instruments)}
        url = self.URL % self.ACCOUNT_ID
        return requests.get(url, headers=self.HEADER, params=params)

        rates = [
            {'symbol': self.base, 'rate':'1', 'name':self.NAMES[self.base]}
        ]
        for symbol, rate in self.parse_rates(self.api_instruments()):
            rates.append(
                 {'symbol': symbol, 'rate': rate, 'name':self.NAMES[symbol]}
            )
        return rates

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


class Openx(object):

    ''' resource from openexchangerates need to change query; use historical
        to get hourly
    '''

    APP_ID = '7f7b54e590004181abf46b48f766bacb'

    url = 'https://openexchangerates.org/api/latest.json'

    def __init__(self, base):
        self.base = base.upper()

    def collect_rates(self):
        response = self.api_call()
        return response.json()['rates']

    def api_call(self):
        params = {'app_id': self.APP_ID, 'base': self.base}
        return requests.get(self.url, params=params)

