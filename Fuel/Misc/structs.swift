//
//  structs.swift
//  Fuel
//
//  Created by Leo Hu on 10/24/24.
//

import Foundation
import SwiftUI

enum Stat {
    case cals
    case carbs
    case protein
    case fat
}

struct Restaurant: Codable, Identifiable {
    let id: Int
    let name: String
}

struct MenuItem: Codable, Identifiable {
    let id: Int
    let itemId: String
    let name: String
}

struct Item: Codable, Identifiable {
    let itemId: String
    let name: String
    let addons: [String : String]
    let sizes: [String : String]
    var id: String { itemId }
}

struct Component: Codable, Identifiable {
    let id: Int
    let name: String
    let calories: Int
    let servingSize: String
    let totalFat: Int
    let satFat: Int
    let transFat: Int
    let chol: Int
    let na: Int
    let totalCarbs: Int
    let fiber: Int
    let totalSugar: Int
    let addedSugar: Int
    let protein: Int
    let ca: Int
    let fe: Int
    let k: Int
    let allergens: String
}

struct Meal: Codable, Identifiable {
    let id: String
    let name: String
    let components: [Component]
}

struct UserData: Codable {
    var uid: String = "testuser123"
    var name: String = "User"
    var weight: Int = 150
    var calorieGoal: Int = 2000
    var carbGoal: Int = 750
    var fatGoal: Int = 500
    var proteinGoal: Int = 500
}

struct DailyRecord: Codable {
    var uid: String = "testuser123"
    var date: String = "11/04/2024"
    var calories: Int = 0
    var fat: Int = 0
    var carbs: Int = 0
    var protein: Int = 0
    var weight: Int = 150
    var meals: [String:[Meal]] = ["breakfast" : [],
        "lunch" : [],
        "dinner" : [],
        "snacks" : []]
    
    mutating func addMeal(meal: Meal, type: String) {
        guard meals.keys.contains(type) else {
                    print("Invalid meal type: \(type). Meal not added.")
                    return
                }

        meals[type, default: []].append(meal)
        print("Meal successfully added to \(type)")
        print(meals)
        
        for component in meal.components {
            calories += component.calories
            fat += component.totalFat
            carbs += component.totalCarbs
            protein += component.protein
        }
    }
}

struct CircularProgressBar: View {
    var progress: Double
    var lineWidth: CGFloat
    var color: Color
    var backgroundColor: Color = .gray.opacity(0.2)

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    backgroundColor,
                    lineWidth: lineWidth
                )
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            Text("\(Int(progress * 100))%")
                .font(.title)
                .bold()
        }
        .padding(lineWidth / 2)
    }
}

struct CompositionBarCircular: View {
    var comp1: Double
    var comp2: Double
    var comp3: Double

    private var total: Double {
        comp1 + comp2 + comp3
    }

    private func trimmedCircle(color: Color, from: CGFloat, to: CGFloat) -> some View {
        Circle()
            .trim(from: from, to: to)
            .stroke(style: StrokeStyle(lineWidth: 25.0, lineCap: .round, lineJoin: .round))
            .foregroundColor(color)
            .rotationEffect(Angle(degrees: 270))
            .animation(.easeInOut, value: total)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 25.0)
                .opacity(0.20)
                .foregroundColor(.gray)

            trimmedCircle(
                color: .cyan,
                from: 0.0,
                to: CGFloat(min(comp1 / total, 1.0))
            )
            trimmedCircle(
                color: .pink,
                from: CGFloat(min(comp1 / total, 1.0)),
                to: CGFloat(min((comp1 + comp2) / total, 1.0))
            )
            trimmedCircle(
                color: .yellow,
                from: CGFloat(min((comp1 + comp2) / total, 1.0)),
                to: CGFloat(min((comp1 + comp2 + comp3) / total, 1.0))
            )
        }
    }
}
