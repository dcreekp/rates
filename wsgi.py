import morepath
from rates3.app import App

morepath.autoscan()
App.commit()
app = App()

