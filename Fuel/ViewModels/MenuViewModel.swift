//
//  MenuViewModel.swift
//  Fuel
//
//  Created by Leo Hu on 10/24/24.
//

import Foundation

final class MenuViewModel: ObservableObject {
    @Published var stage: Int = 0
    @Published var restaurantId: Int?
    @Published var itemId: String? = "25d9a9fa-8a9d-11ef-b97c-ad3c0825f34b"
    
    func next() {
        if(stage < 2){
            stage += 1
        }
    }
    
    func prev() {
        if(stage > 0){
            stage -= 1
        }
    }
}
