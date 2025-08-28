//
//  MovieDetail.swift
//  Klapp
//
//  Created by Alessio Millauro on 22/08/25.
//

import Foundation

struct MovieDetail: Decodable, Identifiable {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let genres: [Genre]
    let originalLanguage: String
    let originalTitle: String
    let overview: String?
    let popularity: Float
    let posterPath: String?
    let releaseDate: String?
    let title: String
    let video: Bool
    let voteAverage: Float
    let voteCount: Int
    let budget: Int
    let revenue: Int
    let runtime: Int
    let credits: MovieCredits?
    let videos: Videos?
    let images: MovieImagesResponse?
    let similarMovies: [NowPlayingMovie]
    
    struct SimilarMoviesResponse: Codable {
        let results: [NowPlayingMovie]
    }
    
    struct Genre: Codable, Identifiable {
        let id: Int
        let name: String
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        adult = try container.decode(Bool.self, forKey: .adult)
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        genres = try container.decodeIfPresent([Genre].self, forKey: .genres) ?? []
        originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        overview = try container.decodeIfPresent(String.self, forKey: .overview)
        popularity = try container.decode(Float.self, forKey: .popularity)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        title = try container.decode(String.self, forKey: .title)
        video = try container.decode(Bool.self, forKey: .video)
        voteAverage = try container.decode(Float.self, forKey: .voteAverage)
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        budget = try container.decodeIfPresent(Int.self, forKey: .budget) ?? 0
        revenue = try container.decodeIfPresent(Int.self, forKey: .revenue) ?? 0
        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime) ?? 0
        credits = try container.decodeIfPresent(MovieCredits.self, forKey: .credits)
        videos = try container.decodeIfPresent(Videos.self, forKey: .videos)
        images = try container.decodeIfPresent(MovieImagesResponse.self, forKey: .images)
        
        // Decodifica corretta dei film simili
        let similarResponse = try container.decodeIfPresent(SimilarMoviesResponse.self, forKey: .similar)
        similarMovies = similarResponse?.results ?? []
    }
    
    enum CodingKeys: String, CodingKey {
        case id, adult, overview, popularity, title, video, budget, revenue, runtime, credits, videos
        case backdropPath = "backdrop_path"
        case genres
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case images = "images"
        case similar = "similar"
    }
}
