//
//  AppCoordinator.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI

final class AppCoordinator: ObservableObject {

    // MARK: - Public API

    var homeCoordinator: HomeCoordinator?

    func start() -> some View {
        homeCoordinator = HomeCoordinator()
        return homeCoordinator?.start(catService: catService)
    }

    // MARK: - Private

    private let catService = CatService()
}
