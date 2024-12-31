//
//  MealStack.swift
//  Fuel
//
//  Created by Leo Hu on 12/26/24.
//

import SwiftUI

struct MealStack: View {
    @State var showMenu = false
    @State var showInfo = false
    @EnvironmentObject var userDataManager: UserDataManager
    var mealName: String
    var type: String
    @State var mealToDisplay: Meal = Meal(id: "0", name: "test", components: [])
    var body: some View {
        VStack(spacing: 0) {
            // Top bar with meal name
            Rectangle()
                .fill(Color.orange)
                .frame(height: 40)
                .overlay {
                    Text(mealName)
                        .bold()
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
            
            Spacer() // Keeps the button pushed down
            
            ForEach(userDataManager.dayRecord.meals[type, default: []]) { meal in
                Button(action: {
                    mealToDisplay = meal
                    showInfo = true
                }) {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.gray.opacity(0.5))
                        .frame(height: 50)
                        .overlay {
                            Text(meal.name)
                                .bold()
                                .foregroundColor(.white)
                        }
                        .contentShape(Rectangle())
                        .padding(10)
                }
            }
            
            //Spacer()

            Button(action: {
                showMenu = true
            }) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(height: 50)
                    .overlay {
                        Image(systemName: "plus.app.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .opacity(0.75)
                            .foregroundColor(.gray)
                    }
            }
            .contentShape(Rectangle())
            .padding(10)
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .background{
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.gray.opacity(0.3))
        }
        .padding(5)
        .sheet(isPresented: $showMenu) {
            MenuView(mealType: type, show: $showMenu)
                .presentationDetents([.fraction(0.999)])
        }
        .sheet(isPresented: $showInfo) {
            MealInfo(meal: $mealToDisplay)
                .presentationDetents([.fraction(0.999)])
        }
        //.id(mealToDisplay.id)
    }
}

#Preview {
    MealStack(mealName: "test", type: "snacks")
        .environmentObject(UserDataManager.shared)
}
