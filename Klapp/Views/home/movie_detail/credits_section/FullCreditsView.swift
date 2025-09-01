//
//  FullCreditsView.swift
//  Klapp
//
//  Created by Alessio Millauro on 28/08/25.
//

import SwiftUICore
import SwiftUI

struct FullCreditsView: View {
    let credits: MovieCredits?
    
    @Binding var isPresented: Bool
    
    private let columns = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]
    
    init(credits: MovieCredits?, isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self.credits = credits
    }
    
    var body: some View {
            NavigationView {
                ScrollView {
                    if let credits = credits {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(credits.cast) { credit in
                                CreditItemView(credit: credit)
                            }
                        }
                        .padding()
                    } else {
                        Text("Nessun credito disponibile")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
                .navigationTitle("Cast & Crew")
                .navigationBarTitleDisplayMode(.inline)
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
