//
//  MealInfo.swift
//  Fuel
//
//  Created by Leo Hu on 12/26/24.
//

import SwiftUI

struct MealInfo: View {
    @Binding var meal: Meal
    
    var body: some View {
        ScrollView {
            VStack {
                Text(meal.name)
                    .bold()
                    .font(.system(size: 36))
                    .padding()

                // Compute meal macro sums
                let mealInfo = mealMacroSum(meal: meal)
                let carbs = Double(mealInfo["carbs"] ?? 0)
                let protein = Double(mealInfo["protein"] ?? 0)
                let fats = Double(mealInfo["fats"] ?? 0)
                let totalCals = Double(mealInfo["total"] ?? 0)
                
                HStack {
                    ZStack {
                        CompositionBarCircular(
                            comp1: carbs,
                            comp2: protein,
                            comp3: fats
                        )
                        .frame(width: 150)
                        .padding(5)
                        VStack {
                            Text("\(Int(totalCals))")
                                .bold()
                                .font(.system(size: 48))
                            Text("kCAL")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    VStack {
                        HStack {
                            Text("Carbs")
                                .bold()
                                .font(.system(size: 18))
                            Spacer()
                        }
                        HStack {
                            Text("\(String(format: "%.1f", (carbs * 4 / totalCals * 100)))%")
                                .foregroundColor(.cyan)
                                .bold()
                                .font(.system(size: 24))
                            Spacer()
                            Text("-----")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(Int(carbs))g")
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 5)

                        HStack {
                            Text("Proteins")
                                .bold()
                                .font(.system(size: 18))
                            Spacer()
                        }
                        HStack {
                            Text("\(String(format: "%.1f", (protein * 4 / totalCals * 100)))%")
                                .foregroundColor(.pink)
                                .bold()
                                .font(.system(size: 24))
                            Spacer()
                            Text("-----")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(Int(protein))g")
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 5)
                        
                        HStack {
                            Text("Fats")
                                .bold()
                                .font(.system(size: 18))
                            Spacer()
                        }
                        HStack {
                            Text("\(String(format: "%.1f", (fats * 9 / totalCals * 100)))%")
                                .foregroundColor(.yellow)
                                .bold()
                                .font(.system(size: 24))
                            Spacer()
                            Text("-----")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(Int(fats))g")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                }
                .padding()
                
                VStack {
                    Text("Components")
                        .bold()
                        .font(.system(size: 24))
                    ForEach(meal.components) { component in
                        ComponentInfo(component: component)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func mealMacroSum(meal: Meal) -> [String: Int] {
        // Initialize results
        var ret: [String: Int] = ["total": 0, "carbs": 0, "protein": 0, "fats": 0]
        
        // Sum up macros
        for comp in meal.components {
            let carbs = comp.totalCarbs // Safely unwrap optionals
            let protein = comp.protein
            let fats = comp.totalFat
            
            ret["carbs"]! += carbs
            ret["protein"]! += protein
            ret["fats"]! += fats
            ret["total"]! += (carbs * 4) + (protein * 4) + (fats * 9) // Total calories
        }
        
        return ret
    }
}

struct ComponentInfo: View {
    @State private var show = false
    var component: Component
    
    var body: some View {
        ZStack {
            if show {
                details()
            } else {
                thumbnail()
            }
        }
    }
    
    @ViewBuilder
    private func thumbnail() -> some View {
        HStack {
            // Component name stays in place
            Text(component.name)
                .bold()
                .font(.system(size: 24))
                .padding(.leading, 20) // You can adjust this padding for desired spacing
            
            Spacer()
            
            // Button to toggle details visibility
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    show.toggle()
                }
            }) {
                Image(systemName: "chevron.down")
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .padding(10) // Add padding for a larger tap area
            }
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.gray.opacity(0.3))
        }
        .padding(.horizontal)  // Padding to ensure the background fills the container
    }

    @ViewBuilder
    private func details() -> some View {
        let allergendict: [String: String] = [
            "A": "Garlic",
            "B": "Gluten",
            "C": "Eggs Allergen",
            "D": "Fish Allergen",
            "E": "Milk Allergen",
            "F": "Peanut Allergen",
            "G": "Sesame Allergen",
            "H": "Shellfish Allergen",
            "I": "Soy Allergen",
            "J": "Tree Nuts Allergen",
            "K": "Wheat Allergen"
        ]
        
        VStack {
            // Component name stays in place
            HStack {
                Text(component.name)
                    .bold()
                    .font(.system(size: 24))
                    .padding(.leading, 20) // Same padding to keep alignment consistent
                
                Spacer()
                
                // Button to toggle details visibility
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        show.toggle()
                    }
                }) {
                    Image(systemName: "chevron.up")
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .padding(10)  // Add padding for a larger tap area
                }
            }
            
            // Additional detail content (this won't affect the layout of the button or name)
            macroDisplay(macroName: "Calories", macroValue: component.calories, macroUnits: "kCAL", macroColor: .orange)
            macroDisplay(macroName: "Carbs", macroValue: component.totalCarbs, macroUnits: "g", macroColor: .cyan)
            macroDisplay(macroName: "Protein", macroValue: component.protein, macroUnits: "g", macroColor: .pink)
            macroDisplay(macroName: "Fat", macroValue: component.totalFat, macroUnits: "g", macroColor: .yellow)

            // Display allergens
            HStack {
                Text("Allergens")
                    .font(.system(size: 18))
                    .bold()
                    .padding(.leading, 40)
                    .padding(.trailing, 20)
                Text("--------")
                    .foregroundColor(.gray)
                Spacer()
                
                VStack {
                    // For each character in the allergens string
                    ForEach(component.allergens.map { String($0) }, id: \.self) { allergenKey in
                        if let allergen = allergendict[allergenKey] {
                            Text(allergen)
                                .font(.system(size: 16))
                                .padding(.top, 2)
                        }
                    }
                }
                .padding(.trailing, 40)
            }
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.gray.opacity(0.3))
        }
        .padding(.horizontal)  // Padding to ensure the background fills the container
    }

    @ViewBuilder
    private func macroDisplay(macroName: String, macroValue: Int, macroUnits: String, macroColor: Color) -> some View {
        HStack {
            Text(macroName)
                .font(.system(size: 18))
                .bold()
                .padding(.leading, 40)
                .padding(.trailing, 20)
            Text("--------")
                .foregroundColor(.gray)
            Spacer()
            Text("\(macroValue)")
                .font(.system(size: 24))
                .foregroundColor(macroColor)
                .bold()
            Text(macroUnits)
                .padding(.trailing, 40)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    MealInfo(meal: Binding(get: { return Meal(id: "ibdiqwbd", name: "Test", components: [Component(id: 3, name: "test component", calories: 100, servingSize: "12 oz", totalFat: 15, satFat: 5, transFat: 5, chol: 5, na: 5, totalCarbs: 5, fiber: 5, totalSugar: 5, addedSugar: 5, protein: 5, ca: 5, fe: 5, k: 5, allergens: "ABCD")]) }, set: { _ in }))
}
             
