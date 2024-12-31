import Foundation

@MainActor
final class UserDataManager: ObservableObject {
    public static var shared = UserDataManager()
    
    @Published var weeklyRecord: [String:DailyRecord] = [:]
    @Published var dayRecord: DailyRecord = DailyRecord()
    @Published var userData: UserData = UserData()
    @Published var uid: String = "testuser123"
    
    init() {
        Task {
            do {
                let formatter = DateFormatter()
                let calendar = Calendar.current
                formatter.dateFormat = "MM/dd/yyyy"
                let today = Date()
                for i in 1...6 {
                    if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                        let formattedDate = formatter.string(from: date)
                        weeklyRecord[formattedDate] = try await APIManager.shared.getDailyRecord(uid: uid, date: formattedDate)
                    }
                }
                let currentDate = formatter.string(from: today)
                dayRecord = try await APIManager.shared.getDailyRecord(uid: uid, date: currentDate)
                userData = try await APIManager.shared.getUserData(uid: uid)
            } catch {
                print("Could not get daily record: \(error)")
            }
        }
    }

    func addMeal(name: String, components: [Component], type: String) {
        let newMeal = Meal(id: UUID().uuidString, name: name, components: components)
        dayRecord.addMeal(meal: newMeal, type: type)
        print("New Meal added: \(newMeal)")
        Task {
            do {
                try await APIManager.shared.updateDailyRecord()
            } catch {
                print("An error occurred while updating the data: \(error)")
            }
        }
    }
}
