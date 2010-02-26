use web, fastcgi
import web/[Server, Application]
import fastcgi/fcgx
import io/[Reader, Writer]


/**
 * A ooc.web compatible Server.
 * See http://github.com/joshthecoder/ooc-web for more details.
 */
FCGIServer: class extends Server {
    socketPath: String
    backlog: Int
    _socket: Int

    init: func(=socketPath) { backlog = 128 }
    init: func ~withBacklog (=socketPath, =backlog) {}

    run: func -> Bool {
        // Initialize FCGX
        if (FCGX init() != 0) return false

        // Open socket
        _socket = FCGX openSocket(socketPath, backlog)
        if (_socket == -1) return false

        // Initialize the FCGI request object
        fcgi: FCGXRequest
        if (FCGX initRequest(fcgi&, _socket, FCGX failAcceptOnInterrupt) != 0) return false

        // Begin listening for requests
        while (FCGX accept(fcgi&) == 0) {
            // parse and setup request
            request := FCGIRequest new(fcgi envp, fcgi in)
            request path = FCGX getParam("REQUEST_URI", fcgi envp)
            request method = FCGX getParam("REQUEST_METHOD", fcgi envp)
            request remoteAddress = FCGX getParam("REMOTE_ADDR", fcgi envp)
            request remoteHost = FCGX getParam("REMOTE_HOST", fcgi envp)
            request remotePort = FCGX getParam("REMOTE_PORT", fcgi envp)

            // dispatch request to Application
            application request = request
            application response = FCGIResponse new(fcgi out)
            application processRequest()
        }

        return true
    }
}

FCGIRequest: class extends Request {
    _envp: Pointer
    stream: FCGXStream*

    init: func(=_envp, =stream) {}

    getHeader: func(name: String) -> String {
        value := FCGX getParam("HTTP_%s" format(name toUpper()), _envp)
        if (value != null) return value clone()
        else return value
    }

    body: func -> Reader {
        FCGIBodyReader new(stream)
    }
}

FCGIResponse: class extends Response {
    stream: FCGXStream*
    bodyWriter: Writer

    init: func(=stream) { bodyWriter = null }

    setStatus: func(code: Int, value: String) {
        if(bodyWriter) Exception new("May not set status code once body() has been called") throw()
        FCGX putString("Status: %d %s\r\n" format(code, value), stream)
    }

    setHeader: func(name: String, value: String) {
        if(bodyWriter) Exception new("May not set header once body() has been called") throw()
        FCGX putString("%s: %s\r\n" format(name, value), stream)
    }

    body: func -> Writer {
        if (!bodyWriter) {
            FCGX putString("\r\n", stream)  // terminate headers
            bodyWriter = FCGIBodyWriter new(stream)
        }
        return bodyWriter
    }
}

FCGIBodyReader: class extends Reader {
    stream: FCGXStream*

    init: func(=stream) {}

    read: func ~string(chars: String, length: Int) -> SizeT {
        bytesRead := FCGX getString(chars, length, stream)
        if (bytesRead == -1) Exception new("Error while reading string") throw()
        marker += bytesRead
        return bytesRead
    }

    read: func(chars: String, offset: Int, count: Int) -> SizeT {
        skip(offset - marker)
        return read(chars, count)
    }

    read: func ~char -> Char {
        c := FCGX getChar(stream)
        if (c == -1) Exception new("Error while reading byte") throw()
        marker += 1
        return c
    }

    hasNext: func -> Bool {
        c := FCGX getChar(stream)
        if (c == -1) return false
        FCGX unGetChar(c, stream)
        return true
    }

    rewind: func(offset: Int) { Exception new("Rewind not supported") throw() }
    mark: func -> Long { marker }
    reset: func(marker: Long) { Exception new("Reset not supported") throw() }
}

FCGIBodyWriter: class extends Writer {
    stream: FCGXStream*

    init: func(=stream) {}

    close: func {}

    write: func ~chr (chr: Char) {
        if (FCGX putChar(chr, stream) == -1) {
            Exception new("Error while sending response body byte") throw()
        }
    }

    write: func(chars: String, length: SizeT) -> SizeT {
        bytes := FCGX putStringWithLength(chars, length, stream)
        if (bytes == -1) {
            Exception new("Error while sending response body string") throw()
        }
        return bytes
    }
}
