//
//  MoviesController.swift
//  HelloBird
//
//  Created by Art Mac M5 on 24/5/2569 BE.
//

import Foundation
import Hummingbird

struct MoviesController {
    
    let repository: MovieRepository
    
    var endPoint: RouteCollection<AppRequestContext> {
        let routeCollection = RouteCollection(context: AppRequestContext.self)
        /*
        routeCollection.get(use: getMovies)
        routeCollection.get(":id", use: getMoviesById)
        routeCollection.post(use: createMovie)
        return routeCollection
         */
    }
    /*
    func getMovies(request: Request, context: some RequestContext) async throws -> [Movie] {
        await repository.getMovies()
    }
    
    func getMoviesById(request: Request, context: some RequestContext) async throws -> Movie? {
        
        guard let movieId = context.parameters.get("id", as: Int.self) else {
            throw HTTPError(.badRequest)
        }
        
        return await repository.movie(movieId)
    }
    
    func createMovie(request: Request, context: some RequestContext) async throws -> Movie {
        let movie = try await request.decode(as: Movie.self, context: context)
        return await repository.createMovie(movie)
    }*/
}
