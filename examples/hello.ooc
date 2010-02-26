use web, fastcgi

import text/StringBuffer
import web/[Application]
import fastcgi/Server


HelloApplication: class extends Application {
    processRequest: func {
        "Request path: %s" format(request path) println()
        "Request method: %s" format(request method) println()
        "Request remote addr: %s port %d" format(request remoteAddress, request remotePort) println()

        response setHeader("Content-type", "text/html")
        out := response body()
        out write("<html><body><h1>Hello world from ooc!!!</h1></body></html>")
    }
}

main: func {
    server := FCGIServer new(":8000")
    server application = HelloApplication new()
    server run()
}

