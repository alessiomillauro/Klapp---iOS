//
//  ProfileView.swift
//  Klapp
//
//  Created by Alessio Millauro on 19/08/25.
//

import SwiftUI
import FirebaseStorage

struct ProfileView: View {
    
    @EnvironmentObject var userManager: UserManager
    
    @State private var showingEditNationality = false
    @State private var newNationality = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // MARK: - Profilo utente
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        let accountImageUrl = userManager.accountInfo.profileImageUrl
                        let url = URL(string: accountImageUrl ?? "N/A")
                        // Immagine profilo
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                        .padding(.top, 16)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(userManager.accountInfo.name ?? "N/A")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(userManager.accountInfo.surname ?? "N/A")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            Text(userManager.accountInfo.email ?? "N/A")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                // MARK: - Nazionalità
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Nazionalità")
                                .font(.headline)
                            
                            Text(userManager.accountInfo.nationality ?? "N/A")
                                .font(.body)
                                .fontWeight(.medium)
                                .id(userManager.accountInfo.nationality) // necessario per trigger animazione
                                .transition(.asymmetric(insertion: .opacity.combined(with: .slide),
                                                        removal: .opacity.combined(with: .slide)))
                                .animation(.easeInOut(duration: 0.4), value: userManager.accountInfo.nationality)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            newNationality = userManager.accountInfo.nationality ?? "N/A"
                            
                            //userManager.editNationality()
                            showingEditNationality = true
                            
                        }) {
                            Label("Modifica", systemImage: "pencil.circle.fill")
                                .labelStyle(.iconOnly)
                                .font(.title2)
                        }
                    }
                    
                    Text("La nazionalità viene usata per filtrare i contenuti delle chiamate web.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    Task {
                        await userManager.logout()
                    }
                }) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                }
                .padding(.horizontal)
                .padding(.bottom, 20) // spazio dal bordo inferiore
            }
            .padding(.vertical)
        }
        .navigationTitle("Profilo")
        .sheet(isPresented: $showingEditNationality) {
            EditNationalitySheet(
                currentNationality: $newNationality,
                onSave: {
                    Task {
                        await userManager.updateUserNationality(nationality: newNationality)
                        showingEditNationality = false
                    }
                },
                onCancel: {
                    showingEditNationality = false
                }
            )
        }
    }
}

