//
//  MenuView.swift
//  Fuel
//
//  Created by Leo Hu on 10/24/24.
//

import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    @State private var restaurants: [Restaurant] = []
    @State private var menuItems: [MenuItem] = []
    @State private var item: Item?
    @State private var sizes: [String] = []
    @State private var addons: [String] = []
    @State private var selectedSize: String = ""
    @State private var selectedAddons: [String] = []
    
    @State var mealType: String
    @Binding var show: Bool
    
    @State private var errorMsg: String?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                if let error = errorMsg {
                    Text(error)
                }
                switch viewModel.stage {
                case 0:
                    restaurantView
                case 1:
                    menuView
                case 2:
                    itemView
                case _:
                    restaurantView
                }
            }
            .padding()
            if(viewModel.stage > 0) {
                Button(action: {
                    viewModel.prev()
                }) {
                    Text("Back")
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    var restaurantView: some View {
        List(restaurants) { restaurant in
            Button(action: {
                viewModel.restaurantId = restaurant.id
                viewModel.next()
            }) {
                Text(restaurant.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .task {
            do {
                self.restaurants = try await APIManager.shared.getRestaurants()
            } catch {
                errorMsg = "Failed to fetch restaurants: \(error)"
            }
        }
    }
    
    @ViewBuilder
    var menuView: some View {
        List(menuItems) { menuItem in
            Button(action: {
                viewModel.itemId = menuItem.itemId
                viewModel.next()
            }) {
                Text(menuItem.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .task {
            do {
                self.menuItems = try await APIManager.shared.getMenuItems(restaurantId: viewModel.restaurantId ?? 1)
            } catch {
                errorMsg = "Failed to fetch restaurants: \(error)"
            }
        }
    }
    
    @ViewBuilder
    var itemView: some View {
        VStack {
            Text(item?.name ?? "placeholder")
            List {
                Section(header: Text("Sizes")) {
                    ForEach(sizes, id: \.self) { size in
                        Button(action: {
                            if selectedSize != size {
                                selectedSize = size
                            }
                        }) {
                            HStack {
                                Text(size)
                                Spacer()
                                Image(systemName: selectedSize == size ? "checkmark.circle.fill" : "circle")
                            }
                            .foregroundColor(.black)
                        }
                    }
                }
                Section(header: Text("Add Ons")) {
                    ForEach(addons, id: \.self) { addon in
                        Button(action: {
                            if let index = selectedAddons.firstIndex(of: addon) {
                                selectedAddons.remove(at: index)
                            } else {
                                selectedAddons.append(addon)
                            }
                        }) {
                            HStack {
                                Text(addon)
                                Spacer()
                                Image(systemName: selectedAddons.contains(addon) ? "checkmark.square.fill" : "square")
                            }
                            .foregroundColor(.black)
                        }
                    }
                }
            }
            Button(action: {
                Task {
                    do {
                        var componentIds:[String] = []
                        for selectedAddon in selectedAddons {
                            componentIds.append(item?.addons[selectedAddon] ?? "")
                        }
                        componentIds.append(item?.sizes[selectedSize] ?? "")
                        let components = try await APIManager.shared.getComponentInfo(componentIds: componentIds)
                        UserDataManager.shared.addMeal(name: item?.name ?? "", components: components, type: mealType)
                        show = false
                    } catch {
                        errorMsg = "Failed to fetch components"
                    }
                }
            }) {
                Text("Add Meal")
            }
        }
        .task {
            do {
                item = try await APIManager.shared.getItemInfo(itemId: viewModel.itemId ?? "")
                sizes = item?.sizes.map { $0.key } ?? []
                addons = item?.addons.map { $0.key } ?? []
                selectedSize = sizes.first ?? ""
            } catch {
                errorMsg = "Failed to fetch item: \(error)"
            }
            
        }
    }
    
}

#Preview {
    MenuView(mealType: "snacks", show: Binding(get: {return true}, set: {_ in }))
}
