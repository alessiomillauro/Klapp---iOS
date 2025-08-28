//
//  MovieImagesModel.swift
//  Klapp
//
//  Created by Alessio Millauro on 25/08/25.
//

struct MovieImagesResponse: Codable {
    let backdrops: [MovieImage]?
    let logos: [MovieImage]?
    let posters: [MovieImage]?
}
