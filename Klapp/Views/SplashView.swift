//
//  SplashView.swift
//  Klapp
//
//  Created by Alessio Millauro on 19/08/25.
//

import SwiftUICore
import SwiftUI

struct SplashView:View {
    @State var isActive: Bool = false
    @EnvironmentObject var userManager : UserManager
    
    var body: some View {
        ZStack {
            if isActive {
                AuthGateView()
            } else {
                Color.black.ignoresSafeArea()
                Image("LiyickyLogoWhite").resizable().scaledToFit().frame(width: 300, height: 300)
            }
        }
        .onAppear {
            Task {
                await loadUserData()
            }
        }
    }
    
    @MainActor
    private func loadUserData() async {
        print("🔄 SplashView: Avvio caricamento dati utente")
        await userManager.loadInitialuserData()
        
        // Stampa dati caricati
        switch userManager.userDataLoadState {
        case .loaded(_):
            print("✅ UserData caricata con successo")
            print("Account info: \(userManager.accountInfo)")
            print("Favorite Movies: \(userManager.favoriteMovies.map { $0.movieTitle ?? "N/A" })")
            print("Recent Searches: \(userManager.recentSearchMovies.map { $0.movieTitle ?? "N/A" })")
        case .error(let message):
            print("⚠️ Errore caricamento dati utente: \(message)")
        default:
            print("⏳ Stato dati utente: \(userManager.userDataLoadState)")
        }
        
        // Dopo un piccolo delay, vai a MainTabView
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 secondi
        withAnimation(.easeInOut) {
            isActive = true
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
