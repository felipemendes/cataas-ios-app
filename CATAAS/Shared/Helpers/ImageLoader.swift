//
//  ImageLoader.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI
import Combine

protocol ImageLoaderProtocol {
    var image: UIImage? { get }
    var imageSubscription: AnyCancellable? { get }

    func fetchImage()
}

final class ImageLoader: ObservableObject, ImageLoaderProtocol {

    // MARK: - Initializer

    init(fileManager: LocalFileManagerProtocol = LocalFileManager(), url: URL, imageName: String) {
        self.fileManager = fileManager
        self.url = url
        self.imageName = imageName
    }

    // MARK: - Public API

    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var error: NetworkingError? = nil

    var imageSubscription: AnyCancellable?

    func fetchImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            print("✅ Retrieving local image for URL: \(url.absoluteString)")
        } else {
            downloadImage()
            print("⚠️ Downloading remote image for URL: \(url.absoluteString)")
        }
    }

    // MARK: - Private

    private let fileManager: LocalFileManagerProtocol
    private let url: URL
    private let imageName: String
    private let folderName = AppConstants.imageFolderName

    private func downloadImage() {
        isLoading = true
        imageSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> UIImage? in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw NetworkingError.badURLResponse(url: self.url)
                }
                return UIImage(data: result.data)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {
                    return
                }

                self.isLoading = false

                switch completion {
                case .finished: break
                case .failure(let error):
                    if let networkingError = error as? NetworkingError {
                        self.error = networkingError
                    } else {
                        self.error = .unknown
                    }
                    print("Error downloading image: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] image in
                guard let self = self,
                      let downloadedImage = image else {
                    return
                }

                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
