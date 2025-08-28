//
//  KlappApp.swift
//  Klapp
//
//  Created by Alessio Millauro on 18/08/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct KlappApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    @StateObject private var userManager = UserManager()
    
    var body: some Scene {
        WindowGroup {
            SplashView().environmentObject(userManager)
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.hideTabBar) private var hideTabBar
    
    var body: some View {
        TabView {
            NavigationStack {
                DashboardView(viewModel: DashboardViewModel(userManager: userManager))
            }
            .tabItem{
                Label("Home", systemImage: "house.fill")
            }.tag(0)
            
            NavigationStack {
                LocationView()
            }
            .tabItem {
                Label("Cinema", systemImage: "film.fill")
            }.tag(1)
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profilo", systemImage: "person.fill")
            }.tag(2)
        }
        .opacity(hideTabBar ? 0 : 1)
        .animation(.easeInOut, value: hideTabBar)
    }
}


private struct HideTabBarKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var hideTabBar: Bool {
        get { self[HideTabBarKey.self] }
        set { self[HideTabBarKey.self] = newValue }
    }
}
