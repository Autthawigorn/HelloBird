import Configuration
import Hummingbird
import Logging
import PostgresNIO


// Request context used by application
typealias AppRequestContext = BasicRequestContext

///  Build application
/// - Parameter reader: configuration reader
func buildApplication(reader: ConfigReader) async throws -> some ApplicationProtocol {
    let logger = {
        var logger = Logger(label: "HelloBird")
        logger.logLevel = reader.string(forKey: "log.level", as: Logger.Level.self, default: .info)
        return logger
    }()
    
    var movieRepository: MovieRepository?
    var router: Router<AppRequestContext>
    
    let client = PostgresClient(configuration: .init(host: "localhost", username: "postgres", password: nil, database: "moviesdb", tls: .disable))
                                                     
    let repository = MovieRepository(client: client)
    movieRepository = repository
    
                                                     
    router = try buildRouter(repository)
    let app = Application(
        router: router,
        configuration: ApplicationConfiguration(reader: reader.scoped(to: "http")),
        logger: logger
    )
    return app
}

/// Build router
func buildRouter(_ repository: MovieRepository) throws -> Router<AppRequestContext> {
    let router = Router(context: AppRequestContext.self)
    // Add middleware
    router.addMiddleware {
        // logging middleware
        LogRequestsMiddleware(.info)
    }
    
    router.addRoutes(MoviesController(repository: repository).endPoint, atPath: "api/movies")
    
    return router
}
