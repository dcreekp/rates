from .app import App
from .model import Openx


@App.path(model=Openx, path='/api/xnepo/{base}/')
def get_openx(base):
    return Openx(base)
