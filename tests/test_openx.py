import pytest

from decimal import Decimal
from rates3 import model

from .mock_data import OPENX_200
from . import client


def test_openx(client):
    response = client.get('/api/xnepo/usd')
    assert response.status_code == 200

@pytest.fixture
def openx_jpy():
    return model.Openx('jpy')

@pytest.fixture
def openx_usd():
    return model.Openx('usd')

def test_openx_api_latest(openx_usd):
    response = openx_usd.api_latest()
    assert response.status_code == 200
    assert response.json()['rates'].keys() == OPENX_200['rates'].keys()

def test_openx_convert_rates():
    pass

def test_openx_collect_quotes():
    pass

def test_openx_collect_rates(openx_usd):
    rates = openx_usd.collect_rates()
    assert isinstance(rates, dict)

def test_openx_invert_base(openx_jpy):
    assert openx_jpy.invert_base(OPENX_200['rates']) == Decimal('0.00900812')

def test_openx_convert(openx_jpy):
    assert openx_jpy.convert('3.7502', Decimal('0.00900812')) == '0.0337823'

def test_openx_api_currency_list():
    pass
def test_openx_api_currency_list_wrong():
    pass
def test_openx_api_latest():
    pass
def test_openx_api_latest_wrong():
    pass

