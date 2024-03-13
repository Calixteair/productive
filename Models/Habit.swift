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
    case Tuesday = "TUE"
    case Wednesday = "WED"
    case Thursday = "THU"
    case Friday = "FRI"
    case Saturday = "SAT"
    case Sunday = "SUN"
    case all = "all"
}


struct Habit: Identifiable {
    var id = UUID()
    var name: String
    var noftification: Bool
    var timesheet: String
    var quantity: Int
    var quantityDone: Int
    var status: Status
    var streak: Int
    var repetition: [Day] = []

    
    
    
    static var habitData = [
        Habit(name: "call prarent",noftification: true,timesheet:"12h32", quantity: 1,quantityDone: 0,status: .toDo, streak: 5, repetition: [.all]),
        Habit(name: "call dog",noftification: false,timesheet:"12h32", quantity: 3,quantityDone: 2,status: .toDo, streak: 0, repetition: [.Friday,.Monday]),
        Habit(name: "run",noftification: false,timesheet:"12h32", quantity: 1,quantityDone: 1,status: .done, streak: 10, repetition: [.all])
        
    ]
}
