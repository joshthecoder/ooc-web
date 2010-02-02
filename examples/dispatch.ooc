use web, fastcgi

import web/[Application, Dispatcher]
import fastcgi/Server
import structs/HashMap


RootApplication: class extends Application {
    sendHeaders: func(headers: HashMap<String>) {
        headers["Content-type"] = "text/plain"
    }
}

ListApplication: class extends Application {
    name: String

    init: func ~withName (=name) {}

    sendResponse: func(response: ResponseWriter) {
        response write("Application %s\n" format(name))
    }
}

main: func {
    dispatcher := Dispatcher new()
    dispatcher applications add(RootApplication new())
    dispatcher applications add(ListApplication new("A"))
    dispatcher applications add(ListApplication new("B"))
    dispatcher applications add(ListApplication new("C"))

    server := FCGIServer new(":8000")
    server application = dispatcher
    server run()    
}
