use web
import web/Request
import structs/HashMap

ResponseWriter: abstract class {
    write: abstract func(data: String) -> Int
    flush: abstract func
}

Application: class {
    parseRequest: func(request: Request) {}
    sendHeaders: func(headers: HashMap<String>) {}
    sendResponse: func(writer: ResponseWriter) {}
}

