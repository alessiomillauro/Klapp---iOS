//
//  MovieSectionView.swift
//  Klapp
//
//  Created by Alessio Millauro on 28/08/25.
//

import SwiftUICore
import SwiftUI

struct MovieCreditsSection: View {
    let credits: MovieCredits
    let onViewAll:() -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Cast & Crew")
                    .font(.headline)
                    .bold()
                Spacer()
                Button("Vedi tutto", action: onViewAll)
                    .font(.subheadline)
            }
            
            VStack(spacing: 16) {
                // Prima riga → max 3
                HStack(spacing: 12) {
                    ForEach(credits.cast.prefix(3)) { credit in
                        CreditItemView(credit: credit)
                    }
                }
                
                // Seconda riga → successivi 2
                HStack(spacing: 12) {
                    ForEach(credits.cast.dropFirst(3).prefix(2)) { credit in
                        CreditItemView(credit: credit)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemGray6)).shadow(color: .black.opacity(0.1),radius: 4, x: 0, y: 2))
            
        }
        .padding(.horizontal)
    }
}
