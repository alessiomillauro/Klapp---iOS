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
                if let credits = credits, !credits.cast.isEmpty {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(credits.cast) { credit in
                            CreditItemView(credit: credit)
                        }
                    }
                    .padding()
                } else {
                    Text("no_data_available")
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .navigationTitle("Cast & Crew")
            .navigationBarTitleDisplayMode(.inline)
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

struct FullCreditsView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with credits data
        FullCreditsView(
            credits: mockMovieCredits,
            isPresented: .constant(true)
        )
        .environment(\.locale, .init(identifier: "en"))
        .previewDisplayName("With Credits")
        
        // Preview without credits data
        FullCreditsView(
            credits: nil,
            isPresented: .constant(true)
        )
        .environment(\.locale, .init(identifier: "it"))
        .previewDisplayName("No Credits")
    }
}

// Mock data for the preview
let mockMovieCredits = MovieCredits(
    cast: [
        MovieCast(adult: false, gender: 2, id: 1, knownForDepartment: "Acting", name: "Chris Evans", originalName: "Chris Evans", popularity: 50.0, profilePath: "/ryu4713m7Yd238vj4Lg4jP4d3P4.jpg", castId: 100, character: "Captain America", creditId: "123", order: 1),
        MovieCast(adult: false, gender: 2, id: 2, knownForDepartment: "Acting", name: "Robert Downey Jr.", originalName: "Robert Downey Jr.", popularity: 60.0, profilePath: "/1G0g9L3H4k34j2K1F3x3k2P2T4q.jpg", castId: 101, character: "Iron Man", creditId: "124", order: 2),
        MovieCast(adult: false, gender: 1, id: 3, knownForDepartment: "Acting", name: "Scarlett Johansson", originalName: "Scarlett Johansson", popularity: 55.0, profilePath: "/3G4k34j2K1F3x3k2P2T4q.jpg", castId: 102, character: "Black Widow", creditId: "125", order: 3),
        MovieCast(adult: false, gender: 2, id: 4, knownForDepartment: "Acting", name: "Mark Ruffalo", originalName: "Mark Ruffalo", popularity: 45.0, profilePath: "/4G5k34j2K1F3x3k2P2T4q.jpg", castId: 103, character: "Hulk", creditId: "126", order: 4),
    ],
    crew: [] // The view only uses the 'cast' property
)
