//
//  File.swift
//  HelloBird
//
//  Created by Art Mac M5 on 24/5/2569 BE.
//

import Foundation
import Hummingbird

struct MovieController {
    
    let movieStore: MovieStore
    
    var endPoint: RouteCollection<AppRequestContext> {
        let routeCollection = RouteCollection(context: AppRequestContext.self)
        routeCollection.get(use: getMovies)
        return routeCollection
    }
    
    func getMovies(request: Request, context: some RequestContext) async throws -> String {
        "Movies"
    }
}
