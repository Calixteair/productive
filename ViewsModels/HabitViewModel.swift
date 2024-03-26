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
        historyInit()
    }
    
    func getHabits(){
        habits.append(contentsOf: Habit.habitData)
    }
    
    func filterTodayHabits(){
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let calendar = Calendar.current
            let filtered = self.habits.filter{
                return calendar.isDate($0.timesheet,inSameDayAs: self.currentDay)
            }
            
            DispatchQueue.main.async {
                
                    self.filteredHabits = filtered
            
                
                
            }
        }
        
    }
    
    func historyInit(){
        self.history = LisHistory.histoData
        print(self.history)
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
    
    func addItem(title: String, notification: Bool, timesheet: Date, quantity: Int, repetition: [Day], unit: String) {

        let newHabit = Habit(name: title,notification: notification,timesheet: timesheet, quantity: quantity,quantityDone: 0, status: .toDo, streak: 0, repetition: repetition, unit:unit)
        habits.append(newHabit)
    }
    
    
    func pushInHistory(id: Int){
        var habitinfo = habits[id]
        var finishhabit = ItemHistory(idHabit: habitinfo.id, streak: habitinfo.streak+1, date: Date(), status: .done)
        LisHistory.histoData.items.append(finishhabit)
        print("add in histor")
        
    }
    
    func updateItem(habit: Habit){
        for ( index, td) in habits.enumerated(){
            if(td.id == habit.id){
                habits[index].status = .done
                
                
            }
        }
    }
}

