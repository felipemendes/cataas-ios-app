//
//  AppCoordinator.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI

final class AppCoordinator: ObservableObject {

    private(set) var homeCoordinator = HomeCoordinator()
    private let catService = CatService()
    private let networkLogger = AppLogger(subsystem: "com.cataas", category: "networking")
    
    func start() -> some View {
        return homeCoordinator.start(
            catService: catService,
            appLogger: networkLogger)
    }
}
