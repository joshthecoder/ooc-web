use web, fastcgi
import web/[Server, Application]
import fastcgi/fcgx


/**
 * A ooc.web compatible Server.
 * See http://github.com/joshthecoder/ooc-web for more details.
 */
FCGIServer: class extends Server {
    socketPath: String
    backlog: Int
    _socket: Int

    init: func(=socketPath) { backlog = 128 }
    init: func ~withBacklog (=socketPath, =backlog) {}

    run: func -> Bool {
        // Initialize FCGX
        if (FCGX init() != 0) return false

        // Open socket
        _socket = FCGX openSocket(socketPath, backlog)
        if (_socket == -1) return false

        // Initialize the FCGI request object
        fcgi: FCGXRequest
        if (FCGX initRequest(fcgi&, _socket, FCGX failAcceptOnInterrupt) != 0) return false

        // Begin listening for requests
        while (FCGX accept(fcgi&) == 0) {
            // parse and setup request
            request := FCGIRequest new(fcgi envp)
            request path = FCGX getParam("REQUEST_URI", fcgi envp)
            request method = FCGX getParam("REQUEST_METHOD", fcgi envp)
            request remoteAddress = FCGX getParam("REMOTE_ADDR", fcgi envp)
            request remoteHost = FCGX getParam("REMOTE_HOST", fcgi envp)
            request remotePort = FCGX getParam("REMOTE_PORT", fcgi envp)

            // dispatch request to Application
            application request = request
            application response = FCGIResponse new(fcgi out)
            responseBody := application processRequest()

            // send response body
            if (responseBody) {
                FCGX putString("\r\n", fcgi out)
                while (responseBody hasNext()) {
                    if (FCGX putChar(responseBody read(), fcgi out) == -1) {
                        Exception new(This, "Write error while sending response body!") throw()
                    }
                }
            }
        }

        return true
    }
}

FCGIRequest: class extends Request {
    _envp: Pointer

    init: func(=_envp) {}

    getHeader: func(name: String) -> String {
        value := FCGX getParam("HTTP_%s" format(name toUpper()), _envp)
        if (value != null) return value clone()
        else return value
    }
}

FCGIResponse: class extends Response {
    stream: FCGXStream*

    init: func(=stream) {}

    sendStatus: func(code: Int, value: String) {
        FCGX putString("Status: %d %s\r\n" format(code, value), stream)
    }

    sendHeader: func(name: String, value: String) {
        FCGX putString("%s: %s\r\n" format(name, value), stream)
    }
}
