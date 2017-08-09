from .app import App
from . import model


@App.json(model=model.Oanda)
def view_oanda_rates(self, request):
    print(self.collect_symbols())
    return {
        'base': self.base,
        'rates': self.rates,
        'symbols': self.collect_symbols(),
        'uri': request.link(self)
        }


@App.json(model=model.Openx)
def view_openx_rates(self, request):
    return {
        'base': self.base,
        'rates': self.collect_rates(),
        'uri': request.link(self)
        }

