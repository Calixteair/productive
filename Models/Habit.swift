//
//  Habit.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import Foundation


enum Status: String, CaseIterable{
    case done = "done"
    case toDo = "todo"
    case suspend = "suspend"
}

enum Day: String, CaseIterable{
    case Monday = "MON"
    case Models
}


struct Habit: Identifiable {
    var id = UUID()
    var name: String
    var noftification: Bool
    var quantity: Int
    var quantityDone: Int
    var status: Status
    var streak: Int
    
    
    
    static var Habit = [
        Habit(name: "call prarent")
    ]
}
