//
//  LoginViewModel.swift
//  Klapp
//
//  Created by Alessio Millauro on 21/08/25.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class LoginViewModel: ObservableObject {
    // Input
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = true
    
    // UI state
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var didLogin: Bool = false
    
    var isEmailValid: Bool {
        // valida in modo semplice
        email.contains("@") && email.contains(".") && email.count >= 5
    }
    
    var isPasswordValid: Bool {
        password.count >= 6
    }
    
    var canSubmit: Bool {
        isEmailValid && isPasswordValid && !isLoading
    }
    
    // Login
    func signIn(email: String, password: String) async {
        guard canSubmit else { return }
        errorMessage = nil
        isLoading = true
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            didLogin = true
        } catch {
            errorMessage = error.localizedDescription
            print(error.localizedDescription)
        }
        isLoading = false
    }
    
    // Registrazione rapida
    func signUp() async {
        guard isEmailValid, isPasswordValid else { return }
        errorMessage = nil
        isLoading = true
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
            didLogin = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // Reset password
    func resetPassword() async {
        guard isEmailValid else {
            errorMessage = "Inserisci un'email valida per reimpostare la password."
            return
        }
        errorMessage = nil
        isLoading = true
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            errorMessage = "✉️ Ti abbiamo inviato un'email per reimpostare la password."
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
