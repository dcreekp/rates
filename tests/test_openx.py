import pytest

from decimal import Decimal
from rates3 import model

from .mock_data import OPENX_200
from . import client


def test_openx(client):
    response = client.get('/api/xnepo/usd')
    assert response.status_code == 200

@pytest.fixture(scope='module')
def openx_jpy():
    return model.Openx('jpy')

@pytest.fixture(scope='module')
def openx_usd():
    return model.Openx('usd')

def test_api_currency_list_is_the_same_as_stored_NAMES(openx_usd):
    #assert openx_usd.api_currency_list().json() == openx_usd.NAMES
    assert set(openx_usd.api_currency_list().json().keys()) == \
        set(openx_usd.NAMES.keys())
    # todo: store currency_list in database, automatic periodic query to restore

def test_api_latest_succeeds(openx_usd):
    response = openx_usd.api_latest()
    assert response.status_code == 200
    assert response.json()['rates'].keys() == OPENX_200['rates'].keys()

def test_collect_quotes_succeeds(openx_jpy):
    assert openx_jpy.collect_quotes().keys() == OPENX_200['rates'].keys()
    assert isinstance(openx_jpy.collect_quotes(), dict)
    assert set(openx_jpy.collect_quotes()[openx_jpy.base].keys()) == \
        set(['rate', 'name'])

def test_collect_quotes_converts_base_rate_back_to_1(openx_usd, openx_jpy):
    assert {'rate': '1', 'name': 'United States Dollar'} in \
        openx_usd.collect_quotes().values()
    assert {'rate': '1', 'name': 'Japanese Yen'} in \
        openx_jpy.collect_quotes().values()

def test_invert_base(openx_usd):
    assert openx_usd._invert_base(OPENX_200['rates']['JPY']) == \
        Decimal('0.00890476')
    assert openx_usd._invert_base(OPENX_200['rates']['DKK']) == \
        Decimal('0.161720')

def test_convert(openx_jpy):
    assert openx_jpy._convert(3.7502, Decimal('0.00900812')) == '0.0337823'

def test_convert_default(openx_usd):
    assert openx_usd._convert_default(3.7502) == '3.75020'

