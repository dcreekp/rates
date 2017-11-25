from .app import App
from .model import Oanda, Openx


@App.path(model=Oanda, path='/api/oanda/{base}/')
def get_oanda(base):
    return Oanda(base)

@App.path(model=Openx, path='/api/xnepo/{base}/')
def get_openx(base):
    return Openx(base)
