use web
import web/Application

Server: abstract class {
    run: func -> Bool { return false }
    application: Application
}
