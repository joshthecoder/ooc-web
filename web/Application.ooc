import structs/HashMap

Request: class {
    init: func {
        headers = HashMap<String> new()
    }

    path: String
    method: String
    remoteHost: String
    remotePort: Int

    headers: HashMap<String>
}

ResponseWriter: abstract class {
    write: func(data: String) -> Int { return 0}
    flush: func {}
}

Application: abstract class {
    parseRequest: func(request: Request) {}
    sendHeaders: func(headers: HashMap<String>) {}
    sendResponse: func(writer: ResponseWriter) {}
}

