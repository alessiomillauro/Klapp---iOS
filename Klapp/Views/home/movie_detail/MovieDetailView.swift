//
//  MovieDetailView.swift
//  Klapp
//
//  Created by Alessio Millauro on 20/08/25.
//

import SwiftUICore
import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var userManager: UserManager
    
    let movie: NowPlayingMovie
    var namespace: Namespace.ID
    var onDismiss: () -> Void
    //@Binding var isPresented: Bool
    
    @StateObject var viewModel : DashboardViewModel
    
    @State private var isMovieFavorite = false
    @State private var selectedTrailer: VideoResult? = nil
    @State private var showTrailer = false
    @State private var showingFullCreditsView = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            //VStack {
            
            MovieDetailTopAppBar(movie: movie, namespace: namespace, onDismiss: onDismiss)
                .padding(.top, 64)
            
            if let detail = viewModel.detailMovie {
                // Rating / altri dettagli (opzionale)
                MovieRatingView(movie: detail, rating: Double(detail.voteAverage), userManager: userManager)
                    .padding(.horizontal)
                    .padding(.top, 16)
                
                Spacer()
                
                MovieOverviewView(movie: detail).padding(.top, 16)
                
                Spacer(minLength: 32)
                
                if let trailers = detail.videos?.results.filter({$0.type == "Trailer" && $0.site == "YouTube"}), !trailers.isEmpty {
                    MovieVideoSection(trailers: trailers, selectedTrailer: $selectedTrailer, showTrailer: $showTrailer)
                }
                
                Spacer(minLength: 32)
                
                if let credits = detail.credits,
                   !(credits.cast.isEmpty && credits.crew.isEmpty) {
                    MovieCreditsSection(credits: credits, onViewAll: { showingFullCreditsView = true}
                    )
                }
                
                Spacer(minLength: 32)
                
                MovieImagesSection(images: detail.images ?? nil)
                
                Spacer(minLength: 32)
                
                MovieSimilarSection(similar: detail.similarMovies)
                
                Spacer(minLength: 32)
                
            } else {
                ProgressView("Caricamento...").frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: .top)
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadDetailMovie(id: movie.id, appendToResponse: "videos,credits,images,similar")
        }
        .onTapGesture {
            withAnimation(.spring()){
                dismiss()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                Button{
                    withAnimation(.spring()) {
                        onDismiss()
                    }
                } label: {
                    HStack{
                        Image(systemName: "chevron.left")
                        Text("Home")
                    }
                }
            }
        }
        .sheet(isPresented: $showingFullCreditsView) {
            FullCreditsView(credits: viewModel.detailMovie?.credits ?? nil, isPresented: $showingFullCreditsView)
        }
    }
}

struct MovieDetailTopAppBar: View {
    let movie: NowPlayingMovie
    var namespace: Namespace.ID
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MovieBackdrop(urlPath: movie.backdropPath)
                .aspectRatio(16/9, contentMode: .fill)
                .overlay(
                    LinearGradient(
                        colors: [.black.opacity(0.5), .clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .clipped()
            //.ignoresSafeArea(edges: .top)
            
            HStack(alignment: .center, spacing: 16) {
                MoviePoster(urlPath: movie.posterPath)
                    .matchedGeometryEffect(id: movie.id, in: namespace)
                    .frame(width: 120, height: 180)
                    .cornerRadius(12)
                    .shadow(radius: 8)
                
                VStack(alignment: .leading, spacing: 6) {
                    Spacer()
                    Text(movie.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(movie.releaseDate ?? "N/A")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom, 8)
                }
                
                Spacer()
            }
            .padding()
        }
        .padding(.top, 44)
    }
}

// --- MOVIE BACKDROP component ---//
struct MovieBackdrop: View {
    let urlPath: String?
    
    var body: some View {
        GeometryReader { geometry in
            if let urlPath, let url = URL(string: "https://image.tmdb.org/t/p/w780\(urlPath)") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.3) // placeholder
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    case .failure:
                        Color.red // fallback se fallisce il caricamento
                    @unknown default:
                        Color.gray
                    }
                }
            } else {
                Color.gray // fallback se urlPath è nil
            }
        }
        //.aspectRatio(16/9, contentMode: .fit)
        //.cornerRadius(15)
    }
}

// --- MOVIE RATING component ---//
struct MovieRatingView: View {
    let movie: MovieDetail
    var rating: Double
    
    @ObservedObject var userManager: UserManager
    
    @State private var animatedProgress: Double = 0
    @State private var isFavorite: Bool = false
    @State private var animateHeart: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("rating")
                .font(.headline)
                .bold()
            
            HStack(spacing: 16) {
                // --- CIRCLE RATING --- //
                ZStack {
                    Circle()
                        .stroke(lineWidth: 6)
                        .opacity(0.2)
                        .foregroundColor(.blue)
                    
                    Circle()
                        .trim(from: 0, to: animatedProgress / 10)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [.blue, .green]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut(duration: 1.2), value: animatedProgress)
                    
                    Text(String(format: "%.1f", rating))
                        .font(.subheadline)
                        .bold()
                }
                .frame(width: 60, height: 60)
                .frame(maxWidth: .infinity, alignment: .center)
                .onAppear {
                    animatedProgress = rating
                }
                
                // --- TEXT INFO --- //
                VStack(alignment: .leading) {
                    Text("\(movie.voteAverage, specifier: "%.1f") su 10")
                        .font(.title3)
                        .bold()
                    Text("\(movie.voteCount) voti")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.3))
                
                // --- FAVORITE BUTTON --- //
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        isFavorite.toggle()
                        animateHeart = true
                    }
                    
                    // reset dell’animazione dopo un attimo
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        animateHeart = false
                    }
                    Task {
                        await userManager.toggleFavoriteStatus(movieId: movie.id, posterPath: movie.posterPath, movieTitle: movie.title)
                    }
                }) {
                    Image(systemName: userManager.isFavorite(movieId: movie.id) ? "heart.fill" : "heart")
                        .font(.system(size: 26))
                        .foregroundColor(userManager.isFavorite(movieId: movie.id) ? .red : .gray)
                        .scaleEffect(userManager.isFavorite(movieId: movie.id) ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: userManager.favoriteMovies)
                        .padding(8)
                        .background(Color(.systemGray5), in: Circle())
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
    }
}

struct MovieOverviewView:View {
    let movie: MovieDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Overview / descrizione
            Text("overview")
                .font(.headline)
                .bold()
            
            Text(movie.overview ?? "no_data_available")
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(4)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)).shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2))
            //.padding(.horizontal)
        }
        .padding(.horizontal)
    }
}

struct MovieVideoSection:View {
    let trailers: [VideoResult]
    @Binding var selectedTrailer: VideoResult?
    @Binding var showTrailer: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("trailer").font(.headline).bold().padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(trailers, id: \.id) { trailer in
                        Button{
                            selectedTrailer = trailer
                            showTrailer = true
                        } label: {
                            ZStack {
                                AsyncImage(url: URL(string: "https://img.youtube.com/vi/\(trailer.key)/hqdefault.jpg")) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 200, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .shadow(radius: 4)
                            }
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
            }
            .sheet(item: $selectedTrailer) { trailer in
                if let url = URL(string: "https://www.youtube.com/embed/\(trailer.key)") {
                    SafariView(url: url)
                }
            }
        }
    }
}

struct CreditItemView: View {
    let credit: MovieCast
    
    var body: some View {
        VStack(spacing: 8) {
            // Immagine circolare
            if let path = credit.profilePath,
               let url = URL(string: "https://image.tmdb.org/t/p/w185\(path)") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 60, height: 60)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                            .frame(width: 60, height: 60)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                    .frame(width: 60, height: 60)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(Circle())
            }
            
            // Nome + ruolo
            Text(credit.name)
                .font(.footnote)
                .bold()
                .lineLimit(1)
            Text(credit.character)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(width: 80)
    }
}


// --- MOVIE IMAGES component ---//
struct MovieImagesSection: View {
    let images: MovieImagesResponse?
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DisclosureGroup(isExpanded: $isExpanded) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Divider().padding(.vertical, 4)
                    
                    if let logos = images?.logos, !logos.isEmpty {
                        VStack(alignment: .center, spacing: 12) {
                            Text("logos").font(.title2).bold().padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(logos, id: \.filePath) { logo in
                                        if let filePath = logo.filePath,
                                           let url = URL(string: "https://image.tmdb.org/t/p/w154\(filePath)") {
                                            
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: 20)
                                                        .shadow(radius: 2)
                                                case .failure:
                                                    Color.gray.frame(height: 80)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                            .onAppear {
                                                print("Logo url:", url)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        Spacer(minLength: 16)
                    }
                    
                    
                    if let backdrops = images?.backdrops, !backdrops.isEmpty {
                        VStack(alignment: .center, spacing: 12) {
                            Text("gallery").font(.title2).bold().padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(backdrops, id: \.filePath) { backdrop in
                                        if let filePath = backdrop.filePath,
                                           let url = URL(string: "https://image.tmdb.org/t/p/w780\(filePath)") {
                                            
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: 20)
                                                        .shadow(radius: 2)
                                                case .failure:
                                                    Color.gray.frame(height: 80)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                            .onAppear {
                                                print("Backdrop list is empty?: \(backdrops.isEmpty)")
                                                print("Backdrop url:", url)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        Spacer(minLength: 16)
                    }
                    
                    
                    
                    if let posters = images?.posters, !posters.isEmpty {
                        VStack(alignment: .center, spacing: 12) {
                            Text("poster").font(.title2).bold().padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(posters, id: \.filePath) { poster in
                                        if let filePath = poster.filePath,
                                           let url = URL(string: "https://image.tmdb.org/t/p/w780\(filePath)") {
                                            
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    Color.gray.opacity(0.3)
                                                case .success(let image):
                                                    image.resizable().scaledToFill()
                                                case .failure(_):
                                                    Color.red.opacity(0.3)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                            .frame(width: 120, height: 180)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .shadow(radius: 4)
                                            .onAppear {
                                                print("Poster url:", url)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 20)
            } label: {
                HStack {
                    Label("media", systemImage: "photo.on.rectangle.angled")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                .contentShape(Rectangle()) // allarga il tap
            }
            .accentColor(.blue) // icona disclosure in blu
            .animation(.easeInOut, value: isExpanded)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        )
        .padding(.horizontal)
    }
}

/*
 label : {
 Hstack {
 Label("Media", systemImage: "photo.on.rectangle.angled")
 .font(.headline)
 .foregroundColor(.primary)
 
 Spacer()
 }
 .contentShape(Rectangle())
 }
 .accentColor(.blue)
 .animation(.easeInOut, value: isExpanded)
 */

struct MovieSimilarSection: View {
    let similar: [NowPlayingMovie]?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if let similarList = similar, !similarList.isEmpty {
                VStack(alignment: .center, spacing: 12) {
                    Text("similar_movies")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(similarList) { movie in
                                if let filePath = movie.posterPath,
                                   let url = URL(string: "https://image.tmdb.org/t/p/w780\(filePath)") {
                                    
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            Color.gray.opacity(0.3)
                                        case .success(let image):
                                            image.resizable().scaledToFill()
                                        case .failure:
                                            Color.red.opacity(0.3)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    .frame(width: 120, height: 180)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(radius: 4)
                                    .onAppear {
                                        print("Poster url:", url)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    @Namespace static var previewNamespace
    
    static var previews: some View {
        let userManager = UserManager() // Istanza fittizia
        let vm = DashboardViewModel(userManager: userManager)
        
        let sampleMovie = NowPlayingMovie(
            id: 1,
            adult: false,
            backdropPath: nil,
            genreIds: [28,18],
            originalLanguage: "en",
            originalTitle: "Oppenheimer",
            overview: "La storia del ruolo di J. Robert Oppenheimer, i quali studi condussero alle scoperte legate alla bomba atomica, con il conseguente utilizzo durante le stragi di Hiroshima e Nagasaki durante la Seconda Guerra Mondiale.",
            popularity: 120.5,
            posterPath: "/poster_sample.jpg",
            releaseDate: "2025-07-21",
            title: "Oppenheimer",
            video: false,
            voteAverage: 8.7,
            voteCount: 1423
        )
        
        Group {
            MovieDetailView(
                movie: sampleMovie,
                namespace: previewNamespace,
                onDismiss: {},
                viewModel: vm
                //isPresented: .constant(true)
            )
            .preferredColorScheme(.light)
            
            MovieDetailView(
                movie: sampleMovie,
                namespace: previewNamespace,
                onDismiss: {},
                viewModel: vm
                //isPresented: .constant(true)
            )
            .preferredColorScheme(.dark)
        }
    }
}

