use wasp
import wasp/Application

Server: abstract class {
    start: func -> Bool
    stop: func -> Bool

    install: func(path: String, app: Application) -> Int
    remove: func(path: String, position: Int) -> Application
    removeAll: func(path: String)
}
