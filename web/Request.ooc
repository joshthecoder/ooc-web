Request: abstract class {
    path: String
    method: String
    remoteAddress: String
    remoteHost: String
    remotePort: String

    getHeader: abstract func(name: String) -> String
}

