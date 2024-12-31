//
//  GoalsView.swift
//  Fuel
//
//  Created by Leo Hu on 12/24/24.
//

import SwiftUI

struct GoalsView: View {
    @EnvironmentObject var userDataManager: UserDataManager
    
    var body: some View {
        Text("Goals here")
    }
}

#Preview {
    GoalsView()
        .environmentObject(UserDataManager.shared)
}
