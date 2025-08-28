//
//  MoviePoster.swift
//  Klapp
//
//  Created by Alessio Millauro on 20/08/25.
//

import SwiftUICore
import SwiftUI

struct MoviePoster: View {
    let urlPath: String?
    
    var body: some View {
        if let posterPath = urlPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w342\(posterPath)") {
            // Log qui, fuori dalla View
            //print("🔗 URL poster: \(url)")
            
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 200, height: 300)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(15)
                case .failure(_):
                    Image(systemName: "film")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 300)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            //print("❌ posterPath è nil per il film: \(movie.title)")
            Image(systemName: "film")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 300)
                .foregroundColor(.gray)
        }
    }
}
