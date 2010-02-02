import structs/HashMap

Request: abstract class {
}

ResponseWriter: abstract class {
    write: func(data: String) -> Int
    flush: func
}

Application: abstract class {
    parseRequest: func(request: Request)
    sendHeaders: func(headers: HashMap<String>)
    sendResponse: func(writer: ResponseWriter)
}

