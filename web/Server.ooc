use web
import web/Application

Server: abstract class {
    start: func -> Bool
    stop: func -> Bool

    application: Application
}
