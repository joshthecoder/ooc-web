use wasp
use fastcgi

import wasp/Application
import fastcgi/FCGIServer


HelloApplication: class extends Application {
    sendResponse: func(response: ResponseWriter) {
        response write("Hello world from ooc!")
        return true
    }
}

main: func {
    helloApp := HelloApp new()
    server := FCGIServer new(":8000")

    server install("/", helloApp)
    server start()
}

