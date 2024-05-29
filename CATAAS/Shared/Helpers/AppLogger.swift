//
//  LogManager.swift
//  CATAAS
//
//  Created by Felipe Mendes on 28/05/24.
//

import os

protocol LoggerProtocol {
    func debug(_ message: String)
    func info(_ message: String)
    func error(_ message: String)
    func fault(_ message: String)
}

struct AppLogger: LoggerProtocol {
    
    private let logger: Logger

    init(subsystem: String, category: String) {
        logger = Logger(subsystem: subsystem, category: category)
    }

    func debug(_ message: String) {
        logger.debug("\(message, privacy: .public)")
    }

    func info(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }

    func error(_ message: String) {
        logger.error("\(message, privacy: .public)")
    }

    func fault(_ message: String) {
        logger.fault("\(message, privacy: .public)")
    }
}
