//
//  Errors.swift
//  Fuel
//
//  Created by Leo Hu on 10/24/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case encodingFailed
}
