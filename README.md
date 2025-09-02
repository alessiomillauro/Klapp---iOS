Klapp is a mobile application built with SwiftUI following the MVVM architectural pattern.
It allows users to explore the latest movies currently in theaters, upcoming releases, and manage a personal list of favorites.

The app integrates with The Movie Database (TMDB) API for movie data and uses Firebase for authentication and favorites management.

* Language: Swift

* Framework: SwiftUI

* Architecture: MVVM (Model-View-ViewModel)

* Networking: URLSession (with async/await)

* APIs: The Movie Database (TMDB)

* Backend Services: Firebase (Authentication + Firestore Database)


✨ Features
--

- 📽️ Now Playing: Browse the list of movies currently in theaters.

- 🎞️ Coming Soon: Explore upcoming movie releases.

- ❤️ Favorites: Save and manage your personal list of favorite movies (stored via Firestore Database).

- 🔐 Authentication: Sign up / log in using Firebase Authentication.

- 🖼️ Movie Details: View detailed information about each movie, including trailers, cast, and crew.

- 🧭 MVVM Pattern: Clean separation of business logic, networking, and UI layers.

- 🛠️ Tech Stack


___


🚀 Getting Started
--
___Prerequisites___

* Xcode 15 or later

* iOS 17+ (deployment target adjustable if needed)

* A valid TMDB API Key

* A configured Firebase project (Firestore + Authentication enabled)




Installation
--

___Clone the repository:___

>*git clone https://github.com/yourusername/MovieApp.git*
>*cd MovieApp*


___Install dependencies (if using Swift Package Manager / CocoaPods).___

___Add your TMDB API Key in the Constants.swift file.___

___Configure Firebase:___

>1) Download your GoogleService-Info.plist from Firebase Console.
>2) Add it to your Xcode project.

___Run the project on simulator or physical device.___




📸 Screenshots
--

Add screenshots or GIFs of your app here (list, details, favorites, login).




📌 Roadmap
--

 * Offline persistence with CoreData

 * Dark Mode support

 * Unit & UI tests

 * Localization (multi-language support)



🤝 Contributing
--

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.




📄 License
--

This project is licensed under the MIT License – see the LICENSE
 file for details.
