//
//  DashboardView.swift
//  Fuel
//
//  Created by Leo Hu on 10/24/24.
//

import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var userDataManager: UserDataManager
    @State private var restaurants: [Restaurant] = []
    @State private var errorMsg: String?
    @State private var selectedStat: Stat = .cals
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(Date(), style: .date) // Formats as a localized date
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Dashboard")
                            .bold()
                            .font(.system(size: 36))
                        
                    }
                    Spacer()
                }
                HStack {
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundColor(.gray)
                        .frame(height: 200)
                        .opacity(0.5)
                        .overlay {
                            VStack(alignment: .leading) {
                                Text("Goal")
                                    .bold()
                                    .font(.system(size: 24))
                                HStack {
                                    Text("\(userDataManager.userData.calorieGoal)")
                                        .bold()
                                        .foregroundColor(.orange)
                                    Text("CAL")
                                }
                                Spacer()
                                Text("Food")
                                    .bold()
                                    .font(.system(size: 24))
                                HStack {
                                    Text("\(userDataManager.dayRecord.calories)")
                                        .bold()
                                        .foregroundColor(.orange)
                                    Text("CAL")
                                }
                            }
                            .padding(.vertical, 36)
                        }
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundColor(.gray)
                        .frame(height: 200)
                        .opacity(0.5)
                        .overlay {
                            CircularProgressBar(progress: Double(userDataManager.dayRecord.calories)/Double(userDataManager.userData.calorieGoal), lineWidth: 24, color: .orange)
                                .padding(12)
                        }
                }
                HStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.gray)
                        .frame(height: 150)
                        .opacity(0.5)
                        .overlay {
                            VStack {
                                Text("Carbs")
                                    .bold()
                                Spacer()
                                CircularProgressBar(progress: Double(userDataManager.dayRecord.carbs)/Double(userDataManager.userData.carbGoal), lineWidth: 12, color: .cyan)
                            }
                            .padding()
                        }
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.gray)
                        .frame(height: 150)
                        .opacity(0.5)
                        .overlay {
                            VStack {
                                Text("Protein")
                                    .bold()
                                Spacer()
                                CircularProgressBar(progress: Double(userDataManager.dayRecord.protein)/Double(userDataManager.userData.proteinGoal), lineWidth: 12, color: .pink)
                            }
                            .padding()
                        }
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.gray)
                        .frame(height: 150)
                        .opacity(0.5)
                        .overlay {
                            VStack {
                                Text("Fat")
                                    .bold()
                                Spacer()
                                CircularProgressBar(progress: Double(userDataManager.dayRecord.fat)/Double(userDataManager.userData.fatGoal), lineWidth: 12, color: .yellow)
                            }
                            .padding()
                        }
                }
                HStack {
                    Text("Your Weekly Stats")
                        .bold()
                        .font(.system(size: 24))
                    Spacer()
                }
                HStack {
                    Button(action: {
                        selectedStat = .cals
                    }) {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(height: 50)
                            .foregroundColor(selectedStat == .cals ? .orange : .gray.opacity(0.5))
                            .overlay {
                                Text("Cals")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                    }
                    Button(action: {
                        selectedStat = .carbs
                    }) {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(height: 50)
                            .foregroundColor(selectedStat == .carbs ? .cyan : .gray.opacity(0.5))
                            .overlay {
                                Text("Carbs")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                    }
                    Button(action: {
                        selectedStat = .protein
                    }) {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(height: 50)
                            .foregroundColor(selectedStat == .protein ? .pink : .gray.opacity(0.5))
                            .overlay {
                                Text("Protein")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                    }
                    Button(action: {
                        selectedStat = .fat
                    }) {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(height: 50)
                            .foregroundColor(selectedStat == .fat ? .yellow : .gray.opacity(0.5))
                            .overlay {
                                Text("Fats")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                    }
                }
                Chart {
                    // Iterate over the sorted keys (dates) from the weeklyRecord
                    ForEach(userDataManager.weeklyRecord.keys.sorted(), id: \.self) { date in
                        if let dailyRecord = userDataManager.weeklyRecord[date] {
                            switch selectedStat {
                                case .cals:
                                BarMark(
                                    x: .value("Date", date),  // x-axis is the date
                                    y: .value("Calories", dailyRecord.calories)  // y-axis is the stat value (calories, protein, etc.)
                                )
                                    .foregroundStyle(.orange)  // Bar color
                                    .annotation(position: .top) {
                                        Text("\(dailyRecord.calories)")  // Display the stat value as a text annotation on top of the bar
                                            .font(.system(size: 12))
                                    }
                                case .carbs:
                                BarMark(
                                    x: .value("Date", date),  // x-axis is the date
                                    y: .value("Carbs", dailyRecord.carbs)  // y-axis is the stat value (calories, protein, etc.)
                                )
                                    .foregroundStyle(.blue)  // Bar color
                                    .annotation(position: .top) {
                                        Text("\(dailyRecord.carbs)")  // Display the stat value as a text annotation on top of the bar
                                            .font(.system(size: 12))
                                    }
                                case .protein:
                                BarMark(
                                    x: .value("Date", date),  // x-axis is the date
                                    y: .value("Protein", dailyRecord.protein)  // y-axis is the stat value (calories, protein, etc.)
                                )
                                .foregroundStyle(.pink)  // Bar color
                                    .annotation(position: .top) {
                                        Text("\(dailyRecord.protein)")  // Display the stat value as a text annotation on top of the bar
                                            .font(.system(size: 12))
                                    }
                                case .fat:
                                BarMark(
                                    x: .value("Date", date),  // x-axis is the date
                                    y: .value("Fat", dailyRecord.fat)  // y-axis is the stat value (calories, protein, etc.)
                                )
                                    .foregroundStyle(.yellow)  // Bar color
                                    .annotation(position: .top) {
                                        Text("\(dailyRecord.fat)")  // Display the stat value as a text annotation on top of the bar
                                            .font(.system(size: 12))
                                    }
                            }

                            // Create a BarMark using the selected stat as the y-axis value and date as the x-axis value
                        
                        }
                    }

                    let currentDateString = Date().formatted(date: .numeric, time: .omitted)
                    switch selectedStat {
                        case .cals:
                        BarMark(
                            x: .value("Date", currentDateString),  // x-axis is the date
                            y: .value("Calories", userDataManager.dayRecord.calories)  // y-axis is the stat value (calories, protein, etc.)
                        )
                            .foregroundStyle(.orange)  // Bar color
                            .annotation(position: .top) {
                                Text("\(userDataManager.dayRecord.calories)")  // Display the stat value as a text annotation on top of the bar
                                    .font(.system(size: 12))
                            }
                        case .carbs:
                        BarMark(
                            x: .value("Date", currentDateString),  // x-axis is the date
                            y: .value("Carbs", userDataManager.dayRecord.carbs)  // y-axis is the stat value (calories, protein, etc.)
                        )
                            .foregroundStyle(.blue)  // Bar color
                            .annotation(position: .top) {
                                Text("\(userDataManager.dayRecord.carbs)")  // Display the stat value as a text annotation on top of the bar
                                    .font(.system(size: 12))
                            }
                        case .protein:
                        BarMark(
                            x: .value("Date", currentDateString),  // x-axis is the date
                            y: .value("Protein", userDataManager.dayRecord.protein)  // y-axis is the stat value (calories, protein, etc.)
                        )
                        .foregroundStyle(.pink)  // Bar color
                            .annotation(position: .top) {
                                Text("\(userDataManager.dayRecord.protein)")  // Display the stat value as a text annotation on top of the bar
                                    .font(.system(size: 12))
                            }
                        case .fat:
                        BarMark(
                            x: .value("Date", currentDateString),  // x-axis is the date
                            y: .value("Fat", userDataManager.dayRecord.fat)  // y-axis is the stat value (calories, protein, etc.)
                        )
                            .foregroundStyle(.yellow)  // Bar color
                            .annotation(position: .top) {
                                Text("\(userDataManager.dayRecord.fat)")  // Display the stat value as a text annotation on top of the bar
                                    .font(.system(size: 12))
                            }
                    }
                }
                .frame(height: 200)  // Set the chart frame height



            }
            .padding()
        }
        
    }
}

#Preview {
    DashboardView()
        .environmentObject(UserDataManager.shared)
}
