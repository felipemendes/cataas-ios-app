//
//  LocalFileManager.swift
//  CATAAS
//
//  Created by Felipe Mendes on 13/05/24.
//

import SwiftUI

protocol LocalFileManagerProtocol {
    func saveImage(image: UIImage, imageName: String, folderName: String)
    func getImage(imageName: String, folderName: String) -> UIImage?
}

final class LocalFileManager: LocalFileManagerProtocol {

    private let appLogger: LoggerProtocol
    
    init(
        appLogger: LoggerProtocol = AppLogger(subsystem: "com.cataas", category: "file_manager")
    ) {
        self.appLogger = appLogger
    }

    func saveImage(image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)

        guard let data = image.pngData(),
              let url = getURLForImage(imageName: imageName, folderName: folderName) else {
            return
        }

        do {
            try data.write(to: url)
        } catch {
            appLogger.error("Local File Manager Error Saving Image. FolderName: \(folderName): \(error)")
        }
    }

    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }

        return UIImage(contentsOfFile: url.path)
    }

    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }

        return url.appendingPathComponent(folderName)
    }

    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else {
            return
        }

        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                appLogger.error("Local File Manager Error creating directory. FolderName: \(folderName): \(error)")
            }
        }
    }

    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderUrl = getURLForFolder(folderName: folderName) else {
            return nil
        }

        return folderUrl.appendingPathComponent(imageName + ".png")
    }
}
