use web, fastcgi

import web/Application
import fastcgi/Server


HelloApplication: class extends Application {
    parseRequest: func(request: Request) {
        "Request path: %s" format(request path) println()
    }
}

main: func {
    server := FCGIServer new(":8000")
    server application = HelloApplication new()
    server run()
}

