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


def test_hp(browser):
    browser.get('http://localhost:8000')
    assert 'rates3' in browser.title

def test_gbp_page_loads(browser):
    browser.get('http://localhost:8000/#GBP')
    WebDriverWait(browser, 5).until(
        EC.text_to_be_present_in_element_value(
        (By.CSS_SELECTOR, '#from input'), 'GBP')
        )
    display = browser.find_element_by_css_selector('display h2')
    assert 'British Pound' in display.text

def test_jpy_page_loads(browser):
    browser.get('http://localhost:8000/#jpy')
    WebDriverWait(browser, 5).until(
        EC.text_to_be_present_in_element_value(
        (By.CSS_SELECTOR, '#from input'), 'JPY')
        )
    display = browser.find_element_by_tag_name('h2')
    assert 'Japanese' in display.text
