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
    
    @Published var history: LisHistory = LisHistory.histoData
    
    
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
    
    func historyInit(){
        self.history = LisHistory.histoData
        let today = Date()

        let lastday = LisHistory.histoData.lastDay

        // Créer un objet DateFormatter pour formater les dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Format de date à utiliser, adapté à LisHistory.lastDay

        // Vérifier si lastDay est aujourd'hui
        if Calendar.current.isDate(today, inSameDayAs: lastday) {
            print("lastDay est aujourd'hui.")
        } else {
            // Calculer le nombre de jours entre lastDay et aujourd'hui
            let calendar = Calendar.current
            let daysDifference = calendar.dateComponents([.day], from: lastday, to: today).day ?? 0
            print("lastDay n'est pas aujourd'hui. Nombre de jours écoulés depuis lastDay : \(daysDifference)")
            findNotDohabit(nbjour: daysDifference)
            
        }
        
        print(self.history)
    }
    
    
    func findNotDohabit(nbjour: Int){
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for day in 0..<nbjour {
            // date today - day
            if let date = calendar.date(byAdding: .day, value: -day, to: Date()) {
                let dayabv =  self.weekdayToDay(calendar.component(.weekday, from: date))
                print(dayabv)
                for habit in habits {
                    if (habit.repetition.contains(dayabv)){
                        let item = ItemHistory(idHabit: habit.id, streak: 0, date: date, status: .toDo)
                        LisHistory.histoData.items.append(item)
                    }
                }
                
            }
            
        }
        print(LisHistory.histoData)
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
    
    func weekdayToDay(_ weekday: Int) -> Day {
        switch weekday {
            case 1:
                return .Sunday
            case 2:
                return .Monday
            case 3:
                return .Tuesday
            case 4:
                return .Wednesday
            case 5:
                return .Thursday
            case 6:
                return .Friday
            case 7:
                return .Saturday
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
                    pushInHistory(id: index)
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

        let newHabit = Habit(name: title,notification: notification,timesheet: timesheet, quantity: quantity,quantityDone: 0, status: .toDo, streak: 0, repetition: repetition, unit:unit)
        habits.append(newHabit)
        self.filterTodayHabits()
        self.printAllHabitsDetails()

    }
    
    
    func pushInHistory(id: Int){
        let habitinfo = habits[id]
        let finishhabit = ItemHistory(idHabit: habitinfo.id, streak: habitinfo.streak+1, date: Date(), status: .done)
        LisHistory.histoData.items.append(finishhabit)
        print("add in history")
        
    }
    
    func updateItem(habit: Habit){
        for ( index, td) in habits.enumerated(){
            if(td.id == habit.id){
                habits[index].status = .done
                
                
            }
        }
    }
}

