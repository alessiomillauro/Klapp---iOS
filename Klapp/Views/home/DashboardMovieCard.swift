//
//  MovieCard.swift
//  Klapp
//
//  Created by Alessio Millauro on 19/08/25.
//

import SwiftUICore
import SwiftUI

struct DashboardMovieCard: View {
    let movie: NowPlayingMovie
    
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
            
            Text(movie.title)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: posterWidth, alignment: .leading)
            
            Text(movie.releaseDate ?? "N/A")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: posterWidth, alignment: .leading)
        }
        //.frame(width: posterWidth,minH minHeight: posterHeight, alignment: .top)
    }
}
