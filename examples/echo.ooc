use web, fastcgi

import web/Application
import fastcgi/Server

EchoApplication: class extends Application {
    processRequest: func {
        response setHeader("Content-type", "plain/text; charset=utf-8")
        response body() write(request body())
    }
}

main: func {
    server := FCGIServer new(":8000")
    server setApplication(EchoApplication new())
    server run()
}
