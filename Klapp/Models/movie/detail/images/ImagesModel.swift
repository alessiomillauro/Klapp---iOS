//
//  ImagesModel.swift
//  Klapp
//
//  Created by Alessio Millauro on 22/08/25.
//

import Foundation

struct MovieImage: Codable, Identifiable, Hashable {
    let id = UUID()  // Per usare ForEach in SwiftUI
    let aspectRatio: Double?
    let height: Int?
    let iso639_1: String?
    let filePath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let width: Int?
    
    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case iso639_1 = "iso_639_1"
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}
