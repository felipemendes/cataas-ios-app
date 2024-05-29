//
//  ImageLoader.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI
import Combine

protocol ImageLoaderProtocol: ObservableObject {
    var image: UIImage? { get }
    var isLoading: Bool { get }
    var error: NetworkingError? { get }

    func fetchImage()
}

final class ImageLoader: ObservableObject, ImageLoaderProtocol {

    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var error: NetworkingError? = nil

    private let session: URLSession
    private let fileManager: LocalFileManagerProtocol
    private let url: URL
    private let imageName: String
    private var imageSubscription: AnyCancellable?
    private let folderName = AppConstants.imageFolderName

    init(
        session: URLSession = URLSession.shared,
        fileManager: LocalFileManagerProtocol = LocalFileManager(),
        url: URL, imageName: String
    ) {
        self.session = session
        self.fileManager = fileManager
        self.url = url
        self.imageName = imageName
    }

    func fetchImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            self.image = savedImage
            print("✅ Retrieving local image for URL: \(url.absoluteString)")
        } else {
            downloadImage()
            print("⚠️ Downloading remote image for URL: \(url.absoluteString)")
        }
    }

    private func downloadImage() {
        isLoading = true

        imageSubscription = session.dataTaskPublisher(for: url)
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
                self.isLoading = false
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)

                self.imageSubscription?.cancel()
            })
    }
}
