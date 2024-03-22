import CoreData
import UIKit

class DataManager {
    static let shared = DataManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<HabitofDay> = HabitofDay.fetchRequest()
        
        do {
            let habits = try context.fetch(fetchRequest)
            for habit in habits {
                print("id: \(habit.id), date: \(habit.date), status: \(habit.status), streak: \(habit.streak)")
            }
        } catch {
            print("Erreur lors de la récupération des données: \(error.localizedDescription)")
        }
    }
    
    func addHabit(id: Int, date: Date, status: String, streak: Int) {
        let newHabit = HabitofDay(context: context)
        newHabit.id = id
        newHabit.date = date
        newHabit.status = status
        newHabit.streak = streak
        
        do {
            try context.save()
        } catch {
            print("Erreur lors de l'enregistrement des données: \(error.localizedDescription)")
        }
    }
}

