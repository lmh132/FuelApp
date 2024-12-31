//
//  APIManager.swift
//  Fuel
//
//  Created by Leo Hu on 10/24/24.
//

import Foundation

// Define the APIManager class
final class APIManager: ObservableObject {
    public static let shared = APIManager()
    
    func getRestaurants() async throws -> [Restaurant] {
        let endpoint = "https://b3llnjv83j.execute-api.us-east-1.amazonaws.com/dev/menus/getRestaurants"
        
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.requestFailed
            }
            
            let decoder = JSONDecoder()

            do {
                let restaurants = try decoder.decode([Restaurant].self, from: data)
                return restaurants
            } catch {
                throw APIError.decodingFailed
            }
        } catch {
            throw error
        }
    }
    
    func getMenuItems(restaurantId: Int) async throws -> [MenuItem] {
        let endpoint = "https://b3llnjv83j.execute-api.us-east-1.amazonaws.com/dev/menus/getMenuItems"
        
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw APIError.invalidURL
        }
        urlComponents.queryItems = [URLQueryItem(name: "restaurant_id", value: String(restaurantId))]
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.requestFailed
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let items = try decoder.decode([MenuItem].self, from: data)
                return items
            } catch {
                throw APIError.decodingFailed
            }
        } catch {
            throw error
        }
    }
    
    func getItemInfo(itemId: String) async throws -> Item {
        let endpoint = "https://b3llnjv83j.execute-api.us-east-1.amazonaws.com/dev/items/itemInfo"
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw APIError.invalidURL
        }
        urlComponents.queryItems = [URLQueryItem(name: "item_id", value: String(itemId))]
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.requestFailed
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let item = try decoder.decode(Item.self, from: data)
                return item
            } catch {
                throw APIError.decodingFailed
            }
        } catch {
            throw error
        }
    }
    
    func getComponentInfo(componentIds: [String]) async throws -> [Component] {
        let endpoint = "https://b3llnjv83j.execute-api.us-east-1.amazonaws.com/dev/items/fetchComponents"
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        // Convert the array of integers into a comma-separated string
        let componentIdsString = componentIds.map { $0 }.joined(separator: ",")
        urlComponents.queryItems = [URLQueryItem(name: "item_ids", value: componentIdsString)]
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        do {
            // Perform the network request
            let (data, response) = try await URLSession.shared.data(from: url)
            // Check the HTTP response status
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.requestFailed
            }
            
            // Decode the JSON data into an array of Component objects
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let components = try decoder.decode([Component].self, from: data)
            
            return components
        } catch {
            // Handle any errors during the request or decoding process
            throw error
        }
    }
    
    func getUserData(uid: String) async throws -> UserData {
        let endpoint = "https://eq3peiick1.execute-api.us-east-1.amazonaws.com/dev/userdata"
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw APIError.invalidURL
        }
        urlComponents.queryItems = [URLQueryItem(name: "uid", value: uid)]
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.requestFailed
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let userData = try decoder.decode(UserData.self, from: data)
            //print(userData)
            return userData
        } catch {
            throw error
        }
                            
    }
    
    func getDailyRecord(uid: String, date: String) async throws -> DailyRecord {
        let endpoint = "https://eq3peiick1.execute-api.us-east-1.amazonaws.com/dev/dailyrecord"
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw APIError.invalidURL
        }
        urlComponents.queryItems = [URLQueryItem(name: "date", value: date), URLQueryItem(name: "uid", value: uid)]
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.requestFailed
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let dailyRecord = try decoder.decode(DailyRecord.self, from: data)
            //print(dailyRecord)
            return dailyRecord
            
        } catch {
            throw error
        }
    }
    
    
    func updateDailyRecord() async throws -> Void {
        let endpoint = "https://eq3peiick1.execute-api.us-east-1.amazonaws.com/dev/dailyrecord"
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let jsonData = try await encoder.encode(UserDataManager.shared.dayRecord)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Encoded JSON:", jsonString)
            }
            request.httpBody = jsonData
        } catch {
            throw APIError.encodingFailed
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error with PUT request: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("PUT request response status code: \(httpResponse.statusCode)")
            }
        }.resume()
    }
}
