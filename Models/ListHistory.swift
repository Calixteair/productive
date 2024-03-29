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
        ItemHistory(idHabit: Habit.habitData[0].id, streak:Habit.habitData[0].streak-2 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (4 * 24 * 60 * 60)), status: .done),
        ItemHistory(idHabit: Habit.habitData[0].id, streak:Habit.habitData[0].streak-1 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (3 * 24 * 60 * 60)), status: .done)
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




