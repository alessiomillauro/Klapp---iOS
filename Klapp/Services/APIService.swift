//
//  APIServic.swift
//  Klapp
//
//  Created by Alessio Millauro on 18/08/25.
//

import Foundation

class APIService {
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "8b84ec80b5563f7716488487efe066fb"
    
    // https://api.themoviedb.org/3/movie/upcoming?language=it&page=1&region=IT
    func funfetchNowPlaying(region: String) async throws -> [NowPlayingMovie] {
        let url = URL(string: "\(baseURL)/movie/now_playing?api_key=\(apiKey)&language=it&page=1&region=\(region)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(NowPlayingResponse.self , from: data)
        return decoded.results
    }
    
    func funfetchUpcoming(region: String) async throws -> [NowPlayingMovie] {
        let url = URL(string: "\(baseURL)/movie/upcoming?api_key=\(apiKey)&language=it-IT&page=1&region=\(region)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(NowPlayingResponse.self , from: data)
        return decoded.results
    }
    
    func funsearchMovie(query: String) async throws -> [NowPlayingMovie] {
        let url = URL(string: "\(baseURL)/search/movie?api_key=\(apiKey)&language=it-IT&query=\(query)&page=1")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(NowPlayingResponse.self, from: data)
        return decoded.results
    }
    
    // https://api.themoviedb.org/3/movie/1083433?append_to_response=videos%2Ccredits%2Cimages%2Csimilar&language=it' \
    
    func funfetchMovieDetail(id: Int, appendToResponse: String) async throws -> MovieDetail {
        let url = URL(string: "\(baseURL)/movie/\(id)?append_to_response=\(appendToResponse)&api_key=\(apiKey)&language=it&page=1")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(MovieDetail.self, from: data)
        return decoded
    }
    
    // 👇 metodo di debug: ritorna il JSON grezzo
    func fetchRawNowPlaying() async throws -> Data {
        let url = URL(string: "\(baseURL)/movie/now_playing?api_key=\(apiKey)&language=it-IT&page=1")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    // 👇 metodo di debug: ritorna il JSON grezzo
    func fetchRawUpcoming() async throws -> Data {
        let url = URL(string: "\(baseURL)/movie/upcoming?api_key=\(apiKey)&language=it-IT&page=1")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    // 👇 metodo di debug: ritorna il JSON grezzo
    func fetchRawSearchMovie(query: String) async throws -> Data {
        let url = URL(string: "\(baseURL)/search/movie?api_key=\(apiKey)&language=it-IT&query=\(query)&page=1&include_adult=false")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    // 👇 metodo di debug: ritorna il JSON grezzo
    func fetchRawMovieDetail(id: String, appendToResponse: String) async throws -> Data {
        let url = URL(string: "\(baseURL)/movie/\(id)?append_to_response=\(appendToResponse)&api_key=\(apiKey)&language=it&page=1")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
        
    }
}
