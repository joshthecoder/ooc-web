import io/Reader


Request: abstract class {
    path: String
    method: String
    remoteAddress: String
    remoteHost: String
    remotePort: String

    getHeader: abstract func(name: String) -> String
}

Response: abstract class {
    sendStatus: abstract func(code: Int, message: String)
    sendHeader: abstract func(name: String, value: String)
}

Application: abstract class {
    request: Request
    response: Response

    processRequest: abstract func -> Reader
}

