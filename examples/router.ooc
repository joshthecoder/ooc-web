use web, fastcgi
import web/[Application, Router]
import fastcgi/Server


MessageApplication: class extends Application {
    message: String

    init: func ~withMessage (=message) {}

    sendHeaders: func(headers: HeaderMap) {
        headers["Content-type"] = "text/plain"
    }

    sendResponse: func(response: ResponseWriter) {
        response write("Got a message for you: %s" format(message))
    }
}

main: func {
    router := Router new(MessageApplication new("This page does not exist dummy!"))
    router addRoute("^/$", MessageApplication new("Welcome to index!"))
    router addRoute("^/about$", MessageApplication new("This is a routes demo"))
    router addRoute("^/exit$", MessageApplication new("Thanks for stopping by!"))

    server := FCGIServer new(":8000")
    server application = router
    server run()
}

