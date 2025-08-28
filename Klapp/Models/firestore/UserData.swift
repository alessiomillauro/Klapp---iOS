//
//  UserData.swift
//  Klapp
//
//  Created by Alessio Millauro on 21/08/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct UserData: Codable {
    var accountInfo: FirestoreAccount
    var likedMovies : [FirestoreMovie]
    var recentSearchMovies: [FirestoreMovie]
}

struct FirestoreMovie: Codable, Identifiable, Hashable {
    
    var id: Int {movieId ?? 0}
    
    var movieId: Int? = nil
    var posterPath: String? = nil
    var movieTitle: String? = nil
    var likedAt: Date
    var searchedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case movieId
        case posterPath = "poster_path"
        case movieTitle = "movie_title"
        case likedAt = "liked_at"
        case searchedAt = "searched_at"
    }
}

struct FirestoreAccount: Codable, Identifiable {
    var id: String {userId ?? UUID().uuidString}
    
    var userId: String? = nil
    var name: String? = nil
    var surname: String? = nil
    var email: String? = nil
    var password: String? = nil
    var profileImageUrl: String? = nil
    var nationality: String? = nil
    var region: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case userId
        case name
        case surname
        case email
        case password
        case profileImageUrl
        case nationality
        case region
    }
}
