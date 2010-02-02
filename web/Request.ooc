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

