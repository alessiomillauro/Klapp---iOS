//
//  SearchRecentCard.swift
//  Klapp
//
//  Created by Alessio Millauro on 21/08/25.
//

import SwiftUI

struct SearchRecentCard: View {
    let movie: FirestoreMovie
    
    let posterHeight: CGFloat = 250
    let posterWidth: CGFloat = 150
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            MoviePoster(urlPath: movie.posterPath)
                .frame(width: posterWidth, height: posterHeight)
                // DEBUG PURPOSE
                //.background(Color.gray.opacity(0.3))
                .cornerRadius(15)
                .shadow(radius: 6)
            
            Text(movie.movieTitle ?? "N/A")
                .font(.title3)
                .bold()
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: posterWidth, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
    }
}
