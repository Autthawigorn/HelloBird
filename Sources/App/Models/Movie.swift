//
//  Movie.swift
//  HelloBird
//
//  Created by Art Mac M5 on 23/5/2569 BE.
//

import Hummingbird

struct Movie {
    public let id: Int
    public let name: String
    public let year: String
}

extension Movie: ResponseEncodable, Encodable, Decodable {}
