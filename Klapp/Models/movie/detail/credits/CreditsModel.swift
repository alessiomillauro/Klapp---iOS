//
//  CreditsModel.swift
//  Klapp
//
//  Created by Alessio Millauro on 22/08/25.
//

struct MovieCredits: Codable, Hashable {
    let cast: [MovieCast]
    let crew: [MovieCrew]
}
