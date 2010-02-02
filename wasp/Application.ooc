use wasp

import structs/HashMap

Request: abstract class {
}

ResponseWriter: abstract class {
    write: func(data: String) -> Int
    flush: func
}

Application: abstract class {
    parseRequest: func(request: Request) -> Bool
    sendHeaders: func(headers: HashMap<String>) -> Bool
    sendResponse: func(writer: ResponseWriter) -> Bool
}

