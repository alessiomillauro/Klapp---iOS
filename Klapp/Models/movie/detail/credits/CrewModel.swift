//
//  CrewModel.swift
//  Klapp
//
//  Created by Alessio Millauro on 22/08/25.
//

struct MovieCrew: Codable, Identifiable, Hashable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let creditId: String
    let department: String
    let job: String
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id, name, popularity, department, job
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case profilePath = "profile_path"
        case creditId = "credit_id"
    }
}
