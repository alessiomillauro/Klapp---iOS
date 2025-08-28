//
//  Movie.swift
//  Klapp
//
//  Created by Alessio Millauro on 18/08/25.
//

struct NowPlayingMovie: Codable, Identifiable {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]?
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
    
    enum CodingKeys: String, CodingKey {
        case id, adult, overview, popularity, title, video
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    // Inizializzatore custom per Preview / test
    init(
        id: Int,
        adult: Bool,
        backdropPath: String?,
        genreIds: [Int],
        originalLanguage: String,
        originalTitle: String,
        overview: String,
        popularity: Float,
        posterPath: String?,
        releaseDate: String,
        title: String,
        video: Bool,
        voteAverage: Float,
        voteCount: Int
    ) {
        self.id = id
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIds = genreIds
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}


