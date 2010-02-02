use wasp
import wasp/Application

Server: abstract class {
    start: func -> Bool
    stop: func -> Bool

    application: Application
}
