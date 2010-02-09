use web
import web/Application
import structs/LinkedList
import text/regexp/Regexp

/**
 * Routes a request to a specific application by
 * matching the requested path to a matched pattern.
 */
Router: class extends Application {
    _routes: LinkedList<Regexp>
    _currentApp: Application
    _notFoundApp: Application

    init: func ~withNotFound (=_notFoundApp) {
        _routes = LinkedList<Regexp> new()
    }

    init: func ~useDefaultNotFound {
        this(DefaultNotFoundApplication new())
    }

    addRoute: func(pattern: String, app: Application) {
        _routes add(Route new(pattern, app))
    }

    removeRoute: func(pattern: String) {
        //TODO: implement me
    }

    parseRequest: func {
        // Attempt to patch requested path to a route
        for (route: Route in _routes) {
            if (route matches(request path)) {
                _currentApp = route application
                break
            }
        }

        // If no match found, use not found app
        if (!_currentApp) _currentApp = _notFoundApp

        _currentApp request = request
        _currentApp parseRequest()
    }

    sendHeaders: func(headers: HeaderMap) {
        _currentApp sendHeaders(headers)
    }

    sendResponse: func(response: ResponseWriter) {
        _currentApp sendResponse(response)
        _currentApp = null
    }
}

Route: class {
    application: Application
    patternRegexp: Regexp

    init: func(pattern: String, =application) {
        patternRegexp = Regexp new(pattern)
    }

    matches: func(path: String) -> Bool {
        return patternRegexp matches(path)
    }
}

DefaultNotFoundApplication: class extends Application {
    sendHeaders: func(headers: HeaderMap) {
        headers["Content-type"] = "text/html"
    }

    sendResponse: func(response: ResponseWriter) {
        response write("<html><body><h1>Page not found!</h1></body></html>")
    }
}

