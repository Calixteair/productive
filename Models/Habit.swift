//
//  Habit.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import Foundation


enum Status: String, CaseIterable, Codable{
    case done = "done"
    case toDo = "todo"
    case suspend = "suspend"
    
}

enum Day: String, CaseIterable, Codable{
    case Monday = "MON"
    case Tuesday = "TUE"
    case Wednesday = "WED"
    case Thursday = "THU"
    case Friday = "FRI"
    case Saturday = "SAT"
    case Sunday = "SUN"
}


struct Habit: Identifiable  {

    var id = UUID()

    var name: String
    var notification: Bool
    var timesheet: Date
    var quantity: Int
    var quantityDone: Int
    var status: Status
    var streak: Int
    var repetition: [Day] = []
    var unit: String

    func repetitionAsString() -> String {
        let sortedRepetition = repetition.map { Day(rawValue: $0.rawValue)! }
                                              .sorted { Day.allCases.firstIndex(of: $0)! < Day.allCases.firstIndex(of: $1)! }
        
        let allWeekdaysPresent = Set(sortedRepetition) == Set(Day.allCases)
        let weekend = sortedRepetition.contains(.Saturday) && sortedRepetition.contains(.Sunday) && sortedRepetition.count == 2
        let withoutWeekend = !sortedRepetition.contains(.Saturday) &&  !sortedRepetition.contains(.Sunday) && sortedRepetition.count == 5
               
               if allWeekdaysPresent {
                   return "week"
               } else if weekend {
                   return "weekend"
               } else if withoutWeekend{
                   return "During the week"
               }else {
                   return sortedRepetition.map { $0.rawValue }.joined(separator: ", ")
               }
    
    }
    
    func getTimeString() -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "HH:mm"
          
          return dateFormatter.string(from: timesheet)
      }
    
    mutating func updateHabit(name: String? = nil,
                              notification: Bool? = nil,
                              timesheet: Date? = nil,
                              quantity: Int? = nil,
                              quantityDone: Int? = nil,
                              status: Status? = nil,
                              streak: Int? = nil,
                              repetition: [Day]? = nil,
                              unit: String? = nil) {
        if let newName = name {
            self.name = newName
        }
        if let newNotification = notification {
            self.notification = newNotification
        }
        if let newTimesheet = timesheet {
            self.timesheet = newTimesheet
        }
        if let newQuantity = quantity {
            self.quantity = newQuantity
        }
        if let newQuantityDone = quantityDone {
            self.quantityDone = newQuantityDone
        }
        if let newStatus = status {
            self.status = newStatus
        }
        if let newStreak = streak {
            self.streak = newStreak
        }
        if let newRepetition = repetition {
            self.repetition = newRepetition
        }
        if let newUnit = unit {
            self.unit = newUnit
        }
        
            print("Habit name:", self.name)
            print("Notification:", self.notification)
            print("Timesheet:", self.timesheet)
            print("Quantity:", self.quantity)
            print("Repetition:", self.repetition)
            print("Unit:", self.unit)
        
    }

    
    
    
    
    
            
    static var habitData = [
        Habit( name: "call parent", notification: true, timesheet: Date(), quantity: 1, quantityDone: 0, status: .toDo, streak: 7, repetition: [.Monday,.Friday,.Wednesday,.Thursday,.Tuesday], unit: "fois"),
        Habit( name: "call dog", notification: false, timesheet: Date(), quantity: 3, quantityDone: 2, status: .toDo, streak: 0, repetition: [.Sunday,.Saturday], unit: ""),
        Habit( name: "run", notification: false, timesheet: Date(), quantity: 1, quantityDone: 1, status: .done, streak: 10, repetition: [.Monday,.Friday,.Saturday,.Sunday,.Wednesday,.Thursday,.Tuesday], unit: "")
    ]
    
    
    
    
}
