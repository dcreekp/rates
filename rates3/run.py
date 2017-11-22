import morepath
import webob
from webob.exc import HTTPNotFound
from webob.static import FileApp, DirectoryApp
from werkzeug.debug import DebuggedApplication
from werkzeug.serving import run_simple
from rates3.app import App


def run():
    morepath.autoscan()
    App.commit()
    morepath.run(App())

def run_auto():
    morepath.autoscan()

    index = FileApp('index.html')
    dist = DirectoryApp('dist')
    App.commit()
    app = App()

    @webob.dec.wsgify
    def morepath_with_static(request):
        if request.path_info_peek() == '':
            return request.get_response(index)
        elif request.path_info_peek() == 'api':
            return request.get_response(app)
        popped = request.path_info_pop()
        if popped == 'dist':
            return request.get_response(dist)
        else:
            return HTTPNotFound()


    run_simple('localhost', 8000, DebuggedApplication(morepath_with_static),
               use_reloader=True)



if __name__ == '__main__':
    run_auto()
