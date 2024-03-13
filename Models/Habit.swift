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
    
    
    
    static var habitData = [
        Habit(name: "call prarent" , noftification: true,quantity: 5,quantityDone: 3,status: .toDo,streak: 5)
    ]
}
