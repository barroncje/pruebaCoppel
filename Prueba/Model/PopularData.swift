//
//  PopularData.swift
//  Prueba
//
//  Created by Julio Enrique Barrón Castañeda on 06/02/22.
//

import Foundation

struct PopularData: Decodable {
    let page: Int?
    let results: [ResultPopular]?
    let totalPages: Int?
    let totalResults: Int?
}

struct ResultPopular: Decodable {
    let adult: Bool?
    let backdrop_path: String?
    let genre_ids: [Int]?
    let id: Int?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let release_date: String?
    let title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?
}
