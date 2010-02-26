use web
import web/Application

Server: abstract class {
    application: Application

    setApplication: func(=application) {}
    application: func -> Application { application }

    run: func -> Bool { return false }
}
