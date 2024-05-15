//
//  CATAASApp.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI
import Combine

@main
struct CATAASApp: App {
    
    @StateObject private var appCoordinator = AppCoordinator()

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color.theme.accent)
        ]

        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(Color.theme.accent)
        ]

        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
    }

    var body: some Scene {
        WindowGroup {
            appCoordinator.start()
        }
    }
}
