from .app import App
from . import model


@App.json(model=model.Openx)
def view_openx_rates(self, request):
    return {
        'data': {
            'base': self.base,
            'quotes': self.collect_quotes(),
            },
        'uri': request.link(self)
        }

