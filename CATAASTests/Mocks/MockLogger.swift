//
//  MockLogger.swift
//  CATAASTests
//
//  Created by Felipe Mendes on 28/05/24.
//

import Foundation
@testable import CATAAS

class MockLogger: LoggerProtocol {
    var messages: [String] = []
    
    func debug(_ message: String) {
        messages.append("DEBUG: \(message)")
    }
    
    func info(_ message: String) {
        messages.append("INFO: \(message)")
    }
    
    func error(_ message: String) {
        messages.append("ERROR: \(message)")
    }
    
    func fault(_ message: String) {
        messages.append("FAULT: \(message)")
    }
}
