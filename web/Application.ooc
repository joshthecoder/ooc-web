use web
import web/Request
import structs/HashMap

ResponseWriter: abstract class {
    write: func(data: String) -> Int { return 0}
    flush: func {}
}

Application: abstract class {
    parseRequest: func(request: Request) {}
    sendHeaders: func(headers: HashMap<String>) {}
    sendResponse: func(writer: ResponseWriter) {}
}

