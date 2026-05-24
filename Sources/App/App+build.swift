import Configuration
import Hummingbird
import Logging

actor MovieStore {
    private(set) var movies: [Movie] = [
        Movie(id: 1, name: "The Shawshank Redemption", year: "1994"),
        Movie(id: 2, name: "The Godfather", year: "1972"),
        Movie(id: 3, name: "The Dark Knight", year: "2008"),
        Movie(id: 4, name: "The Godfather Part II", year: "1974"),
        Movie(id: 5, name: "12 Angry Men", year: "1957"),
        Movie(id: 6, name: "Schindler's List", year: "1993"),
        Movie(id: 7, name: "Pulp Fiction", year: "1994"),
        Movie(id: 8, name: "The Lord of the Rings: The Return of the King", year: "2003"),
        Movie(id: 9, name: "The Good, the Bad and the Ugly", year: "1966"),
        Movie(id: 10, name: "Fight Club", year: "1999")
    ]
    
    func addMovie(_ movie: Movie) {
        movies.append(movie)
    }
}

let movieStore = MovieStore()


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
    let router = try buildRouter()
    let app = Application(
        router: router,
        configuration: ApplicationConfiguration(reader: reader.scoped(to: "http")),
        logger: logger
    )
    return app
}

/// Build router
func buildRouter() throws -> Router<AppRequestContext> {
    let router = Router(context: AppRequestContext.self)
    // Add middleware
    router.addMiddleware {
        // logging middleware
        LogRequestsMiddleware(.info)
    }
    
    let api = router.group("api")
    let movies = api.group("movies")
    let users = api.group("users")
    
    users.get("/") { request, context in
        "Users"
    }
     
    // Add default endpoint
    router.get("/") { _,_ in
        return "Hello World1234!"
    }
    
    // /api/movies
    movies.get("/") { request, context async in
        await movieStore.movies
    }
    
    
    movies.get("/movies/:movieId") { request, context async throws in
        
        guard let movieId = context.parameters.get("movieId", as: Int.self)
        else {
            throw HTTPError(.badRequest)
        }
        
        let movie = await movieStore.movies.first(where: { $0.id == movieId })
        return movie
    }
    
    movies.post("/movies") { request, context async throws in
        
        let movie = try await request.decode(as: Movie.self, context: context)
        await movieStore.addMovie(movie)
        
        return movie
    }
    
    // /movies/search?q=batman&page=12
    movies.get("/movies/search") { request, context in
        
        let queryParameters = request.uri.queryParameters
        
        guard let q = queryParameters.get("q", as: String.self),
              let page = queryParameters.get("page", as: Int.self) else {
            throw HTTPError(.badRequest)
        }
        
        return "Your query was \(q) and the page number was \(page)"
        
    }

    

    movies.get("/movies/genre/:genre") { request, context in
        
        guard let genre = context.parameters.get("genre", as: String.self)
        else {
            throw HTTPError(.badRequest)
        }
        return "The genre is \(genre)"
    }
    
    movies.get("/movies/genre/:genre/year/:year") { request, context in
        
        guard let genre = context.parameters.get("genre", as: String.self),
              let year = context.parameters.get("year", as: Int.self)
        else {
            throw HTTPError(.badRequest)
        }

        return "The genre is \(genre) and the year is \(year)"
    }
    
    return router
}
