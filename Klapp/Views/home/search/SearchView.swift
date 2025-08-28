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
                TextField("Cerca film...", text: $query)
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
                        Text("Risultati").font(.headline).padding(.horizontal).padding(.top, 16)
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
            .navigationTitle("Cerca")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Chiudi") {
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
        Text("Recenti").font(.headline).padding(.horizontal).padding(.top, 16)
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(userManager.recentSearchMovies, id: \.id) { movie in
                    SearchRecentCard(movie: movie)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
            let userManager = UserManager()
            // Imposta qualche dato fittizio per il preview
            userManager.accountInfo.name = "Mario"
            userManager.accountInfo.surname = "Rossi"
            userManager.accountInfo.nationality = "IT"
            
            return Group {
                SearchView(isPresented: .constant(true), userManager: userManager)
                    .preferredColorScheme(.light)
                
                SearchView(isPresented: .constant(true), userManager: userManager)
                    .preferredColorScheme(.dark)
            }
        }
}
