import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


@pytest.fixture(scope='module')
def browser(request):
    browser = webdriver.Firefox()
    def end():
        browser.quit()
    request.addfinalizer(end)
    return browser


@pytest.fixture()
def homepage(browser):
    browser.get('http://localhost:8000')
    WebDriverWait(browser, 5).until(
        EC.visibility_of_element_located(
        (By.CSS_SELECTOR, 'div p'))
        )
    return browser

def test_hp_loads_with_local_currency_as_base_and_displays_it(homepage):
    '''
    tests that the homepage loads the local currency as the base
    the homepage will redirect to an address with the basecurrency parameter
    '''
    assert 'gbp' in homepage.current_url
    display = homepage.find_element_by_css_selector('display h2')
    assert 'British Pound' in display.text

@pytest.fixture()
def base_jpy(browser):
    browser.get('http://localhost:8000/#jpy')
    WebDriverWait(browser, 5).until(
        EC.text_to_be_present_in_element_value(
        (By.CSS_SELECTOR, '#from input'), 'JPY')
        )
    return browser

def test_jpy_page_loads_and_displays_the_currency_name(base_jpy):
    display = base_jpy.find_element_by_css_selector('display h2')
    assert 'Japanese' in display.text


def test_quoting_currency_selected(base_jpy):
    '''
    test that when a quoting currency is selected the display shows the name of
    the base currency quoting currency and the converted amount is 1
    '''

def test_reloading_page_does_not_change_the_input_amounts(base_jpy):
    '''
    test same amount is displayed when page is reloaded with an incumbant amount
    if the rate has changed then the converted value displayed will correspond
    '''

def test_base_quoting_flip_button(base_jpy):
    '''
    test that when the flip button is clicked the base currency and quoting
    currency switches and the displayed amount is switched
    '''


