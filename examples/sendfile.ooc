use web, fastcgi

import web/Application
import fastcgi/Server
import io/[FileReader, File]


SendFile: class extends Application {
    processRequest: func {
        file := File new("../README")

        response setHeader("Content-type", "text/plain; charset=utf-8")
        response setHeader("Content-length", file size() toString())
        response body() write(FileReader new(file))
    }
}

main: func {
    server := FCGIServer new(":8000")
    server application = SendFile new()
    server run()
}
