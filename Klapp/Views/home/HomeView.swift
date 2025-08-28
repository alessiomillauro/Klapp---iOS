//
//  HomeView.swift
//  Klapp
//
//  Created by Alessio Millauro on 18/08/25.
//

import SwiftUICore
import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel : DashboardViewModel
    
    @State private var showingSearch = false
    @State private var selectedMovie: NowPlayingMovie? = nil
    @State private var showDetail : Bool = false
    
    @State private var startDate: Date? = Date()
    @State private var endDate: Date? = Date()
    
    @Namespace private var animationNamespace
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(alignment: .leading) {
                        // 🔍 Campo di ricerca (stile search bar)
                        Button {
                            showingSearch = true
                        } label: {
                            HStack{
                                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                                Text("Cerca un film...").foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        .padding(.top, 16)
                        
                        Spacer(minLength: 24)
                        
                        // --- Now Playing ---
                        MovieSection(
                            viewModel: viewModel,
                            title: "Now Playing",
                            movies: viewModel.nowPlayingMovies,
                            namespace: animationNamespace,
                            onSelect: { movie in
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    selectedMovie = movie
                                    showDetail = true
                                }
                            }
                        )
                        .task {
                            await viewModel.loadNowPlayingMovies()
                        }
                        
                        Spacer(minLength: 24)
                        
                        MovieSection(
                            viewModel: viewModel,
                            title: "Upcoming",
                            movies: viewModel.upcomingMovies,
                            namespace: animationNamespace,
                            onSelect: {movie in
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    selectedMovie = movie
                                    showDetail = true
                                }
                            }
                        )
                        .task {
                            await viewModel.loadUpcomingMovies()
                        }
                    }
                }
                .navigationTitle(Text("Home"))
                .navigationBarTitleDisplayMode(.automatic)
                .sheet(isPresented: $showingSearch) {
                    SearchView(isPresented: $showingSearch, userManager: viewModel.userManager)
                }
            }
            
            if let movie = selectedMovie, showDetail {
                MovieDetailView(movie: movie, namespace: animationNamespace, onDismiss: {
                    selectedMovie = nil
                    showDetail = false
                }, viewModel: viewModel)
                .zIndex(1)
                .transition(.opacity)
                .environment(\EnvironmentValues.hideTabBar, true)
            }
        }
    }
}

struct MovieSection: View {
    @StateObject var viewModel: DashboardViewModel
    
    let title: String
    let movies: [NowPlayingMovie]
    let namespace: Namespace.ID
    let onSelect: (NowPlayingMovie) -> Void
    
    @State private var showingDatePicker = false
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            //HStack {
            Text(title)
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            /*
             Spacer()
             
             if let start = startDate, let end = endDate {
             Text("\(formatDate(start)) - \(formatDate(end))")
             .font(.caption)
             .foregroundColor(.secondary)
             }
             
             Button {
             showingDatePicker = true
             } label: {
             Image(systemName: "calendar").foregroundColor(.blue)
             }
             */
            //}
            //.padding(.horizontal)
            
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(movies, id: \.id) { movie in
                        DashboardMovieCard(movie: movie)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .matchedGeometryEffect(id: movie.id, in: namespace)
                            .onTapGesture { onSelect(movie) }
                    }
                }
                .padding(.horizontal)
            }
        }
        /*
         // NOT IMPLEMENTED - TMDB NowPlaying request does not accept startDate, endDate as parameters
         
         .sheet(isPresented: $showingDatePicker) {
         //DateRangeUpdateSheet(showingDatePicker: showingDatePicker, startDate: startDate, endDate: endDate)
         }
         */
    }
}

/*
 struct DateRangeUpdateSheet: View {
 @State var showingDatePicker = false
 @State var startDate: Date? = nil
 @State var endDate: Date? = nil
 
 var body: some View {
 VStack(spacing: 16) {
 Text("Seleziona periodo").font(.headline)
 
 DatePicker("Data inizio", selection: Binding(get: { startDate ?? Date()}, set: { startDate = $0 }), displayedComponents: .date)
 
 DatePicker("Data fine", selection: Binding(get: { endDate ?? Date()}, set: { endDate = $0 }), displayedComponents: .date)
 
 Button("Conferma") {
 Task {
 if let startDate = startDate, let endDate = endDate {
 await viewModel.loadNowPlayingMovies(startDate: startDate, endDate: endDate)
 }
 showingDatePicker = false
 }
 }
 .buttonStyle(.borderedProminent)
 .padding(.top, 16)
 
 Spacer()
 }
 .padding()
 }
 }
 */

private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter.string(from: date)
}

struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let poster: String // Nome dell'immagine nel tuo asset catalog
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let userManager = UserManager() // Istanza fittizia
        let vm = DashboardViewModel(userManager: userManager)
        
        // Dati fittizi
        vm.nowPlayingMovies = [
            NowPlayingMovie(
                id: 1,
                adult: false,
                backdropPath: "/backdrop_sample.jpg",
                genreIds: [28, 18],
                originalLanguage: "en",
                originalTitle: "Original 1",
                overview: "Breve descrizione del film",
                popularity: 123.4,
                posterPath: "/poster_sample.jpg",
                releaseDate: "2025-01-01",
                title: "Movie 1",
                video: false,
                voteAverage: 7.5,
                voteCount: 150
            ),
            NowPlayingMovie(
                id: 2, adult: false, backdropPath: "", genreIds: [], originalLanguage: "en",
                originalTitle: "Original 2", overview: "", popularity: 1, posterPath: "",
                releaseDate: "2025-01-02", title: "Movie 2", video: false, voteAverage: 6, voteCount: 120
            )
        ]
        
        vm.upcomingMovies = [
            NowPlayingMovie(
                id: 3, adult: false, backdropPath: nil, genreIds: [], originalLanguage: "en",
                originalTitle: "Original A", overview: "", popularity: 1, posterPath: nil,
                releaseDate: "2025-02-01", title: "Movie A", video: false, voteAverage: 7, voteCount: 80
            ),
            NowPlayingMovie(
                id: 4, adult: false, backdropPath: nil, genreIds: [], originalLanguage: "en",
                originalTitle: "Original B", overview: "", popularity: 1, posterPath: nil,
                releaseDate: "2025-02-02", title: "Movie B", video: false, voteAverage: 8, voteCount: 90
            )
        ]
        
        return NavigationView {
            DashboardView(viewModel: vm)
                .environmentObject(userManager)
        }
    }
}


/**
 var body: some View {
     NavigationView {
       VStack{
         todayView()
         categoryList()
         .padding(5)
         Spacer()
       }
     }
     .navigationBarTitle("")
     .navigationBarHidden(true)
   }
 }
 */
