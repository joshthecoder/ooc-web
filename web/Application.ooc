use web
import web/Request
import structs/HashMap

ResponseWriter: abstract class {
    write: abstract func(data: String) -> Int
    flush: abstract func
}

HeaderMap: class extends HashMap<String> {
    init: func ~headermap {
        init(1)
    }

    init: func ~headermapWithCapacity (capacity: UInt) {
        T = String
        super(capacity)
    }
}

operator [] <T> (map: HeaderMap, key: String) -> T {
    map get(key)
}

operator []= <T> (map: HeaderMap, key: String, value: T) {
    map put(key, value)
}


Application: class {
    request: Request

    parseRequest: func {}
    sendHeaders: func(headers: HeaderMap) {}
    sendResponse: func(response: ResponseWriter) {}
}

