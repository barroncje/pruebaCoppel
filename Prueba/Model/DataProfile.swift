//
//  DataProfile.swift
//  Prueba
//
//  Created by Julio Enrique Barrón Castañeda on 06/02/22.
//

import Foundation

struct DataProfile: Decodable {
    let avatar: Avatar?
    let name: String?
    let username: String?
    let id: Int?
}

struct Avatar: Decodable {
    let gravatar: Gravatar
    let tmdb: Tmdb
}

struct Gravatar: Decodable {
    let hash: String?
}

struct Tmdb: Decodable {
    let avatar_path: String?
}
