import morepath
import webob
from webob.exc import HTTPNotFound
from webob.static import FileApp, DirectoryApp
from rates3.app import App

morepath.autoscan()

index = FileApp('index.html')
dist = DirectoryApp('dist')
App.commit()
app = App()

@webob.dec.wsgify
def morepath_with_static(request):
    popped = request.path_info_pop()
    if popped == 'api':
        return request.get_response(app)
    elif popped == 'dist':
        return request.get_response(dist)
    elif popped == '':
        return request.get_response(index)
    else:
        return HTTPNotFound()


