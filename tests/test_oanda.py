import pytest

from rates3 import model
from . import client


def test_oanda(client):
    response = client.get('/api/oanda/usd')
    assert response.status_code == 200

@pytest.fixture
def oanda_jpy():
    return model.Oanda('jpy')

def test_oanda_model(oanda_jpy):
    assert oanda_jpy.base == 'JPY'

def test_oanda_collect_quotes(oanda_jpy):
    quotes = oanda_jpy.quotes
    assert type(quotes) == dict

def test_oanda_base_rate(oanda_jpy):
    assert str(oanda_jpy.base_rate('112.761', '112.894')) == '112.828'
    assert str(oanda_jpy.base_rate('143.838', '143.913')) == '143.876'

def test_oanda_quote_rate(oanda_jpy):
    assert str(oanda_jpy.quote_rate('112.761', '112.894')) == '0.00886305'
    assert str(oanda_jpy.quote_rate('143.838', '143.913')) == '0.00695043'
