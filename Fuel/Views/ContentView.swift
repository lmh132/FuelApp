//
//  ContentView.swift
//  Fuel
//
//  Created by Leo Hu on 10/24/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userDataManager = UserDataManager.shared
    var body: some View {
        TabView{
            DashboardView()
                .tabItem{
                    Image(systemName: "gauge.with.dots.needle.33percent")
                    Text("Dashboard")
                }
                .environmentObject(userDataManager)
            MealsView()
                .tabItem{
                    Image(systemName: "fork.knife.circle")
                    Text("Meals")
                }
                .environmentObject(userDataManager)
            GoalsView()
                .tabItem{
                    Image(systemName: "checklist")
                    Text("Goals")
                }
                .environmentObject(userDataManager)
            AccountView()
                .tabItem{
                    Image(systemName: "person.fill")
                    Text("My Account")
                }
                .environmentObject(userDataManager)
        }
        .accentColor(.white)
        
    }
}

#Preview {
    ContentView()
}
