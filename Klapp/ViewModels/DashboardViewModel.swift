//
//  DashboardViewModel.swift
//  Klapp
//
//  Created by Alessio Millauro on 18/08/25.
//

import Foundation
import SwiftUICore

@MainActor
class DashboardViewModel:ObservableObject{
    @Published var nowPlayingMovies :[NowPlayingMovie] = []
    @Published var upcomingMovies :[NowPlayingMovie] = []
    @Published var searchMovie : [NowPlayingMovie] = []
    @Published var detailMovie : MovieDetail? = nil
    
    @Published var selectedDateRange: (start: Date?, end: Date?) = (nil, nil)
    
    private let service = APIService()
    
    let userManager: UserManager
    
    init(userManager: UserManager) {
        self.userManager = userManager
    }
    
    func loadNowPlayingMovies(startDate: Date? = nil, endDate: Date? = nil) async {
        let region = userManager.accountInfo.nationality
        
        do {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let start = startDate.map{formatter.string(from: $0)}
            let end = endDate.map{formatter.string(from: $0)}
            
            let movies = try await service.funfetchNowPlaying(region: region ?? "US")
            nowPlayingMovies = filterMovies(movies, mode: .released)
        } catch {
            print("❌ Errore caricamento film:", error)
        }
        
        debugPrintRaw(label: "NowPlaying"){ try await self.service.fetchRawNowPlaying()}
    }
    
    func loadUpcomingMovies() async {
        let region = userManager.accountInfo.nationality
        
        do {
            let movies = try await service.funfetchUpcoming(region: region ?? "US")
            upcomingMovies = filterMovies(movies, mode: .upcoming)
        } catch {
            print("❌ Errore caricamento film:", error)
        }
        
        debugPrintRaw(label: "Upcoming"){try await self.service.fetchRawUpcoming()}
    }
    
    func loadSearchedMovie(query: String) async {
        do {
            searchMovie = try await service.funsearchMovie(query: query)
        } catch {
            print("❌ Errore ricerca film:", error)
        }
        
        debugPrintRaw(label: "Search(\(query))") {try await self.service.fetchRawSearchMovie(query: query)}
    }
    
    func loadDetailMovie(id: Int, appendToResponse: String) async {
        do {
            detailMovie = try await service.funfetchMovieDetail(id: id, appendToResponse: appendToResponse)
        } catch {
            print("❌ Errore caricamento dettaglio film:", error)
        }
        
        debugPrintRaw(label: "Movie detail") {try await self.service.fetchRawMovieDetail(id: String(id), appendToResponse: appendToResponse)}

    }
    
    enum FilterMode{
        case released
        case upcoming
    }
    
    func filterMovies(_ movies: [NowPlayingMovie], mode: FilterMode) -> [NowPlayingMovie] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let today = Calendar.current.startOfDay(for: Date())
        
        return movies.filter { movie in
            guard let releaseDate = formatter.date(from: movie.releaseDate ?? "N/A") else {
                return false
            }
            
            switch mode {
            case .released:
                return releaseDate <= today
            case .upcoming:
                return releaseDate > today
            }
        }
    }
    
    /// Stampa di debug per i JSON grezzi
    private func debugPrintRaw(
        label: String = "DEBUG",
        awaitResult: @escaping () async throws -> Data
    ) {
        Task {
            do {
                let rawData = try await awaitResult()
                if let jsonString = String(data: rawData, encoding: .utf8) {
                    print("📦 [\(label)] JSON ricevuto:\n", jsonString)
                }
            } catch {
                print("❌ [\(label)] Errore ottenendo JSON grezzo:", error)
            }
        }
    }
}
