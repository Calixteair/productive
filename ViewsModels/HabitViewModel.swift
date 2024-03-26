 //
//  HabitViewModel.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import Foundation


class HabitViewModel: ObservableObject {
    
    @Published var habits: [Habit] = []
    
    @Published var currentWeek: [Date] = []
    
    @Published var currentDay: Date = Date()
    
    @Published var filteredHabits: [Habit]?
    
    func fetchCurrentWeek(){
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else{
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date( byAdding: .day , value: day , to:firstWeekDay ){
                currentWeek.append(weekday)
                
            }
            
        }
    }
    
    
    
    
    
    func extractDate(date:Date , format: String)-> String{
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
        
    }
    
    
    func isToday(date: Date)->Bool{
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
        
    }
    
    init() {
        getHabits()
        fetchCurrentWeek()
        filterTodayHabits()
    }
    
    func getHabits(){
        habits.append(contentsOf: Habit.habitData)
    }
    
    func filterTodayHabits(){
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let calendar = Calendar.current
            let filtered = self.habits.filter{ habit in
                return habit.repetition.contains(where: { $0.rawValue == self.weekdayToDayString(calendar.component(.weekday, from: self.currentDay)) })
            }
            
            DispatchQueue.main.async {
                
                    self.filteredHabits = filtered
            
                
                
            }
        }
        
    }
    
    
    
    func weekdayToDayString(_ weekday: Int) -> String {
        switch weekday {
            case 1:
                return Day.Sunday.rawValue
            case 2:
                return Day.Monday.rawValue
            case 3:
                return Day.Tuesday.rawValue
            case 4:
                return Day.Wednesday.rawValue
            case 5:
                return Day.Thursday.rawValue
            case 6:
                return Day.Friday.rawValue
            case 7:
                return Day.Saturday.rawValue
            default:
                fatalError("Invalid weekday")
        }
    }
    

     
    
    
    
    func completHabit(habit : Habit){
        for ( index, td) in habits.enumerated(){
            if(td.id == habit.id && habits[index].status != .done){
                habits[index].quantityDone = habits[index].quantity
                if(habits[index].quantityDone >= habits[index].quantity){
                    habits[index].quantityDone = habits[index].quantity
                    habits[index].status = .done
                    habits[index].streak += 1
                }

            }
        }
        
    }
    
    
    func deleteItem(indexSet: IndexSet){
        habits.remove(atOffsets: indexSet)
    }
    
    func suspendHabit(habit: Habit){
        for ( index, td) in habits.enumerated(){
            if(td.id == habit.id){
                habits[index].status = .suspend
            }
        }
    }
    
    func moveItem(from: IndexSet, to: Int){
        habits.move(fromOffsets: from, toOffset: to)
    }
    
    func updateHabit(updatedHabit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == updatedHabit.id }) else {
            print("Habit with id \(updatedHabit.id) not found.")
            return
        }
        
        habits[index] = updatedHabit
        filterTodayHabits()
    }
    
    
    func printAllHabitsDetails() {
        print("Total Habits:")
        for habit in habits {
            print("Name: \(habit.name)")
            print("Notification: \(habit.notification)")
            print("Timesheet: \(habit.timesheet)")
            print("Quantity: \(habit.quantity)")
            print("Quantity Done: \(habit.quantityDone)")
            print("Status: \(habit.status.rawValue)")
            print("Streak: \(habit.streak)")
            print("Repetition: \(habit.repetitionAsString())")
            print("Unit: \(habit.unit)")
            print("--------------")
        }
    }
    
    func addItem(title: String, notification: Bool, timesheet: Date, quantity: Int, repetition: [Day], unit: String) {
            
        let newHabit = Habit(name: title,notification: notification,timesheet: timesheet, quantity: quantity,quantityDone: 0,status: .toDo, streak: 0, repetition: repetition, unit:unit)
        
        habits.append(newHabit)
        self.filterTodayHabits()
        self.printAllHabitsDetails()

    }
    
    func updateItem(habit: Habit){
        for ( index, td) in habits.enumerated(){
            if(td.id == habit.id){
                habits[index].status = .done
                
            }
        }
    }
}

