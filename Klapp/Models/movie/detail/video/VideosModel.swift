//
//  Videos.swift
//  Klapp
//
//  Created by Alessio Millauro on 22/08/25.
//

struct VideoResult: Codable, Identifiable, Hashable {
    let id: String
    let iso639_1: String
    let iso3166_1: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, key, site, size, type, official
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case publishedAt = "published_at"
    }
}

struct Videos: Codable, Hashable {
    let results: [VideoResult]
}
