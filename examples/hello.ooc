use web
use fastcgi

import web/Application
import fastcgi/FCGIServer


HelloApplication: class extends Application {
    sendResponse: func(response: ResponseWriter) -> Bool {
        response write("Hello world from ooc!")
        return true
    }
}

main: func {
    helloApp := HelloApp new()
    server := FCGIServer new(":8000")

    server install(helloApp)
    server start()
}

