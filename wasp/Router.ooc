use wasp
import wasp/Application

/**
 * Routes a request to a specific application by
 * matching the requested path to a matched pattern.
 */
Router: class extends Application {
    addRoute: func(pattern: String, app: Application) {
        //TODO: implement me
    }

    removeRoute: func(pattern: String) {
        //TODO: implement me
    }
}
