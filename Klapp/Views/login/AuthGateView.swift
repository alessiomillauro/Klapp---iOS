//
//  AuthGateView.swift
//  Klapp
//
//  Created by Alessio Millauro on 21/08/25.
//

import SwiftUICore
import FirebaseAuth
import SwiftUI

struct AuthGateView: View {
    @State private var isAuthenticated: Bool = Auth.auth().currentUser != nil
    @State private var isLoadingUserData = false
    @State private var userDataLoaded = false
    
    var body: some View {
        Group {
            if isAuthenticated {
                if userDataLoaded{
                    MainTabView()
                } else {
                    ProgressView("Caricamento dati utente...")
                }
            } else {
                LoginView {
                    withAnimation { isAuthenticated = true}
                }
            }
        }
        .onAppear {
            Auth.auth().addStateDidChangeListener { _, user in
                if let _ = user {
                    withAnimation {isAuthenticated = true}
                    Task {
                        isLoadingUserData = true
                        //await loadeUserData()
                        isLoadingUserData = false
                        withAnimation { userDataLoaded = true}
                    }
                } else {
                    withAnimation { isAuthenticated = (user != nil) }
                }
            }
        }
    }
}
