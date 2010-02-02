use web, fastcgi

import web/[Application]
import fastcgi/Server


HelloApplication: class extends Application {
    parseRequest: func {
        "Request path: %s" format(request path) println()
        "Request method: %s" format(request method) println()
        "Request remote addr: %s port %d" format(request remoteAddress, request remotePort) println()
    }

    sendHeaders: func(headers: HeaderMap) {
        headers["Content-type"] = "text/html"
    }

    sendResponse: func(response: ResponseWriter) {
        response write("<html>"). write("<body>"). write("<h1>Hello!</h1>"). write("</body></html>")
    }
}

main: func {
    server := FCGIServer new(":8000")
    server application = HelloApplication new()
    server run()
}

