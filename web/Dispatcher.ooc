use web
import web/Application
import structs/LinkedList


/**
 * Dispatches a request to a linked list of
 * applications in order from head to tail.
 */
Dispatcher: class extends Application {
    applications: LinkedList<Application>

    init: func ~dispatch {
        applications = LinkedList<Application> new()
    }

    parseRequest: func {
        for (app: Application in applications) {
            app request = request
            app parseRequest()
        }
    }

    sendHeaders: func(headers: HeaderMap) {
        for (app: Application in applications) {
            app sendHeaders(headers)
        }
    }

    sendResponse: func(response: ResponseWriter) {
        for (app: Application in applications) {
            app sendResponse(response)
        }
    }
}
