import morepath
import rates3
import pytest

from webtest import TestApp as Client


@pytest.fixture(scope='module')
def client():
    morepath.scan(rates3)
    morepath.commit(rates3.App)
    client = Client(rates3.App())
    return client

