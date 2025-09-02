//
//  SearchView.swift
//  Klapp
//
//  Created by Alessio Millauro on 19/08/25.
//

import SwiftUICore
import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var userManager: UserManager
    
    @Binding var isPresented: Bool
    @StateObject private var viewModel: DashboardViewModel
    @State private var query = ""
    @State private var results: [String] = []
    
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    init(isPresented: Binding<Bool>, userManager: UserManager) {
        self._isPresented = isPresented
        // Inizializzazione StateObject con closure
        _viewModel = StateObject(wrappedValue: DashboardViewModel(userManager: userManager))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("search_enter", text: $query)
                //.textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 36)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                    .overlay(HStack{
                        Image(systemName: "magnifyingglass").foregroundColor(.gray).padding(.leading, 8)
                        Spacer()
                        if !query.isEmpty {
                            Button(action: {
                                query = ""
                                viewModel.searchMovie = []
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    })
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)
                    .animation(.easeInOut(duration: 0.2), value: query)
                    .onSubmit {
                        guard query.count >= 3 else { return }
                        Task {
                            await viewModel.loadSearchedMovie(query: query)
                        }
                    }
                
                if query.count < 3 && viewModel.searchMovie.isEmpty {
                    RecentSearchesView(columns: columns, userManager: userManager)
                    //.transition(.opacity.combined(with: .move(edge: .top)))
                } else {
                    ScrollView {
                        Text("searched_recent_title").font(.headline).padding(.horizontal).padding(.top, 16)
                        Spacer(minLength: 16)
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.searchMovie, id: \.id) { movie in
                                SearchMovieCard(movie: movie)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .navigationTitle("search_title")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("close") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct RecentSearchesView: View {
    let columns: [GridItem]
    @ObservedObject var userManager: UserManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("searched_result_title")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 16)
            
            if userManager.recentSearchMovies.isEmpty {
                // Display the "no data" view when the list is empty
                VStack(alignment: .center) {
                    Spacer()
                    
                    // Localization is important here too
                    Text("no_data_available")
                        .foregroundColor(.secondary)
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    // You can add an animation here
                    Image(systemName: "magnifyingglass.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                        .opacity(0.8)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Display the grid when the list is not empty
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(userManager.recentSearchMovies, id: \.id) { movie in
                            SearchRecentCard(movie: movie)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    
    // MARK: - Mock Data and Services
    
    // A mock UserManager with recent search movies
    static func mockUserManagerWithRecentSearches() -> UserManager {
        let manager = UserManager()
        manager.recentSearchMovies = [
            FirestoreMovie(movieId: 1, posterPath: "/path/to/poster1.jpg",movieTitle: "Mock Movie 1",likedAt: Date(), searchedAt: Date()),
            FirestoreMovie(movieId: 2, posterPath: "/path/to/poster2.jpg",movieTitle: "Mock Movie 2", likedAt: Date(), searchedAt: Date()),
            FirestoreMovie(movieId: 3, posterPath: "/path/to/poster3.jpg", movieTitle: "Mock Movie 3", likedAt: Date(), searchedAt: Date())
        ]
        return manager
    }
    
    // A mock UserManager with an empty list of recent searches
    static func mockUserManagerWithoutRecentSearches() -> UserManager {
        let manager = UserManager()
        manager.recentSearchMovies = []
        return manager
    }
    
    // MARK: - Previews
    
    static var previews: some View {
        Group {
            // Preview for the case with recent search results
            SearchView(isPresented: .constant(true), userManager: mockUserManagerWithRecentSearches())
                .previewDisplayName("With Recent Searches")
                .environmentObject(mockUserManagerWithRecentSearches())
            
            // Preview for the empty case
            SearchView(isPresented: .constant(true), userManager: mockUserManagerWithoutRecentSearches())
                .previewDisplayName("No Recent Searches")
                .environmentObject(mockUserManagerWithoutRecentSearches())
        }
    }
}
