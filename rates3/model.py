import requests
from decimal import Decimal, getcontext
from .utils import OPENX_CURRENCIES
from .tokens import KEYS


class Openx(object):

    DEFAULT_BASE = 'USD'
    APP_ID = KEYS['openx']
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

