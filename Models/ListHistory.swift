//
//  ListHistory.swift
//  Projethabit
//
//  Created by reymond calixte on 26/03/2024.
//

import Foundation


struct LisHistory: Identifiable {
    var id = UUID()
    var items: [ItemHistory]
    var lastDay: Date
    
    
        static var listItems = [
        ItemHistory(idHabit: Habit.habitData[5].id, streak:1, date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (56 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[5].id, streak:2, date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (49 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[5].id, streak:3 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (42 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[5].id, streak:4 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (35 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[5].id, streak:5 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (28 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[5].id, streak:6 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (21 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[5].id, streak:7 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (14 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[5].id, streak:8 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (7 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[5].id, streak:9 , date: Date(), status: .done),
        
        ItemHistory(idHabit: Habit.habitData[4].id, streak:1 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (7 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[4].id, streak: 0 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (6 * 24 * 60 * 60)), status: .toDo),
        ItemHistory(idHabit: Habit.habitData[4].id, streak:1 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (5 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[4].id, streak: 0 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (4 * 24 * 60 * 60)), status: .toDo),
        ItemHistory(idHabit: Habit.habitData[4].id, streak:1 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (3 * 24 * 60 * 60)), status: .done),
        
        
        ItemHistory(idHabit: Habit.habitData[3].id, streak: 1 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (8 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[3].id, streak: 2 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (7 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[3].id, streak: 3 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (6 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[3].id, streak: 4 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (5 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[3].id, streak: 5 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (4 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[3].id, streak: 6 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (3 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[3].id, streak: 7 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (2 * 24 * 60 * 60)), status: .done),
        
        ItemHistory(idHabit: Habit.habitData[1].id, streak: 1 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (12 * 24 * 60 * 60)), status: .done),
        
        ItemHistory(idHabit: Habit.habitData[0].id, streak: 1 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (1 * 24 * 60 * 60)), status: .toDo),
        
        
        
        
        
        
        
        
        
        
        ]


    static var histoData = LisHistory(items: listItems ,lastDay: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (2 * 24 * 60 * 60)))
        
    func printHistory() {
            print("Historique :")
            for item in items {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let dateString = dateFormatter.string(from: item.date)
                print("Habit: \(item.idHabit), Streak: \(item.streak), Date: \(dateString), Status: \(item.status)")
            }
            let lastDayFormatter = DateFormatter()
            lastDayFormatter.dateFormat = "dd/MM/yyyy"
            let lastDayString = lastDayFormatter.string(from: lastDay)
            print("Dernier jour: \(lastDayString)")
        }
}


struct ItemHistory: Identifiable {
    
    
    var id = UUID()
    var idHabit : UUID
    var streak : Int
    var date: Date
    var status: Status
    
    
}




