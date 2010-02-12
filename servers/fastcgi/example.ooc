use fastcgi
import fastcgi/fcgx

main: func {
    FCGX init()
    socket := FCGX openSocket(":8000", 10)
    if (socket == -1) {
        "Failed to open socket!" println()
    }

    else {
        request: FCGXRequest
        FCGX initRequest(request&, socket, FCGX failAcceptOnInterrupt)

        while (FCGX accept(request&) == 0) {
            FCGX putString("Content-type: text/plain\r\n\r\n", request out)
            FCGX putString("Hello\n", request out)
        }
    }
}
