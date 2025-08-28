//
//  UserViewModel.swift
//  Klapp
//
//  Created by Alessio Millauro on 21/08/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var userDataLoadState: UserDataLoadState = .idle
    @Published var accountInfo: FirestoreAccount = FirestoreAccount()
    @Published var favoriteMovies : [FirestoreMovie] = []
    @Published var recentSearchMovies : [FirestoreMovie] = []
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    func loadInitialuserData() async {
        //guard case .idle = userDataLoadState || case .error = userDataLoadState else { return }
        switch userDataLoadState {
        case .idle, .error:
            break  // possiamo procedere al caricamento
        default:
            return  // se è loading o loaded, esci
        }
        
        userDataLoadState = .loading
        
        guard let currentUser = auth.currentUser else {
            self.userDataLoadState = .loaded(nil)
            self.accountInfo = FirestoreAccount()
            self.favoriteMovies = []
            self.recentSearchMovies = []
            return
        }
        
        do {
            async let profileTask = firestore.collection("users_info").document(currentUser.uid).getDocument()
            
            async let favoritesTask = firestore.collection("user_likes").document(currentUser.uid).collection("liked_movies").getDocuments()
            
            async let recentSearchTask = firestore.collection("user_search").document(currentUser.uid).collection("recent_search").getDocuments()
            
            let (profileSnapshot, favoritesSnapshot, searchSnapshot) = try await (profileTask, favoritesTask, recentSearchTask)
            
            print("Profile snapshot: \(profileSnapshot.data() ?? [:])")
            print("Favorites snapshot: \(favoritesSnapshot.documents.map { $0.data() })")
            print("Recent search snapshot: \(searchSnapshot.documents.map { $0.data() })")
            
            if let userProfile = try? profileSnapshot.data(as: FirestoreAccount.self) {
                self.accountInfo = userProfile
            }
            
            let favorites = favoritesSnapshot.documents.compactMap { try? $0.data(as: FirestoreMovie.self) }
            let searches = searchSnapshot.documents.compactMap { try? $0.data(as: FirestoreMovie.self) }
            
            // Stampare i dati decodificati
            print("Favorites decoded: \(favorites)")
            print("Recent searches decoded: \(searches)")
            
            self.favoriteMovies = favorites
            self.recentSearchMovies = searches
            
            let userData = UserData(accountInfo: accountInfo, likedMovies: favorites, recentSearchMovies: searches)
            self.userDataLoadState = .loaded(userData)
        } catch {
            print("Errore caricamento dati: \(error)")
            self.userDataLoadState = .error(error.localizedDescription)
        }
    }
    
    func updateUserNationality(nationality: String) async {
        let currentUser = auth.currentUser!
        do {
            try await firestore.collection("users_info").document(currentUser.uid).setData(["nationality": nationality], merge: true)
            print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
        
        DispatchQueue.main.async {
            self.accountInfo.nationality = nationality
        }
    }
    
    func isFavorite(movieId: Int) -> Bool {
        favoriteMovies.contains{ $0.id == movieId}
    }
    
    func toggleFavoriteStatus(movieId: Int, posterPath: String?, movieTitle: String?) async {
        guard let currentUser = auth.currentUser else {
            print("No authenticated user")
            return
        }
        
        let movieDocRef = firestore.collection("user_likes").document(currentUser.uid).collection("liked_movies").document("\(movieId)")
        
        var currentFavorites = favoriteMovies
        
        if let existingMovie = currentFavorites.first(where: { $0.movieId == movieId }) {
            do {
                try await movieDocRef.delete()
                currentFavorites.removeAll { $0.movieId == movieId}
                await MainActor.run {
                    self.favoriteMovies = currentFavorites
                }
            } catch {
                print("Error removing favorite: \(error.localizedDescription)")
            }
        } else {
            let newFavoriteMovie = FirestoreMovie(movieId: movieId,
                                                  posterPath: posterPath,
                                                  movieTitle: movieTitle,
                                                  likedAt: Date(),
                                                  searchedAt: Date())
            
            let movieData : [String: Any] = ["movieId": newFavoriteMovie.movieId,
                                             "posterPath": newFavoriteMovie.posterPath as Any,
                                             "movieTitle": newFavoriteMovie.movieTitle as Any,
                                             "liked_at": Timestamp(date: newFavoriteMovie.likedAt), "searched_at": newFavoriteMovie.searchedAt]
            
            do {
                try await movieDocRef.setData(movieData)
                currentFavorites.append(newFavoriteMovie)
                await MainActor.run {
                    self.favoriteMovies = currentFavorites
                }
            } catch {
                print("Error adding favorite: \(error.localizedDescription)")
            }
        }
        
        /*
         if let index = favoriteMovies.firstIndex(where: {$0.id == movie.id}) {
         favoriteMovies.remove(at: index)
         } else {
         favoriteMovies.append(movie)
         }
         */
    }
    
    func logout() async {
        do {
            try await auth.signOut()
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
