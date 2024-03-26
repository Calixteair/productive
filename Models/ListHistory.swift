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
        ItemHistory(idHabit: Habit.habitData[0].id, streak:Habit.habitData[0].streak-2 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (2 * 24 * 60 * 60)), status: Habit.habitData[0].status),
        ItemHistory(idHabit: Habit.habitData[0].id, streak:Habit.habitData[0].streak-1 , date: Date(timeIntervalSince1970: Date().timeIntervalSince1970 - (1 * 24 * 60 * 60)), status: Habit.habitData[0].status)
    ]


    static var histoData = LisHistory(items: listItems ,lastDay: Date())
        
    
}


struct ItemHistory: Identifiable {
    
    
    var id = UUID()
    var idHabit : UUID
    var streak : Int
    var date: Date
    var status: Status
    
}




