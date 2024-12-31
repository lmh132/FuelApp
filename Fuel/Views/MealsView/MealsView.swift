//
//  MealsView.swift
//  Fuel
//
//  Created by Leo Hu on 12/24/24.
//

import SwiftUI

struct MealsView: View {
    @EnvironmentObject var userDataManager: UserDataManager
    
    var body: some View {
        ScrollView{
            VStack{
                HStack {
                    VStack(alignment: .leading) {
                        Text(Date(), style: .date) // Formats as a localized date
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Meals")
                            .bold()
                            .font(.system(size: 36))
                        
                    }
                    Spacer()
                }
                MealStack(mealName: "Breakfast", type: "breakfast")
                    .environmentObject(userDataManager)
                MealStack(mealName: "Lunch", type: "lunch")
                    .environmentObject(userDataManager)
                MealStack(mealName: "Dinner", type: "dinner")
                    .environmentObject(userDataManager)
                MealStack(mealName: "Snacks", type: "snacks")
                    .environmentObject(userDataManager)
            }
            .padding()
        }
    }
}



#Preview {
    MealsView()
        .environmentObject(UserDataManager.shared)
}
