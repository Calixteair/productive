 //
//  HabitViewModel.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import Foundation
import UserNotifications



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
    
    
    func isCurrentDay(date: Date)->Bool{
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
        
    }
    
    func isToday(date: Date) -> Bool{
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
        
    }
    
    

    
    init() {
        getHabits()
        fetchCurrentWeek()
        filterTodayHabits()
        historyInit()
        scheduleNotifications()
    }
    
    
    
    
    
    
    func createNotification(for habit: Habit) {
            let content = UNMutableNotificationContent()
            content.title = "Notification pour \(habit.name)"
            content.body = "C'est l'heure de \(habit.name)"
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: habit.timesheet), repeats: true)

            let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                   if let error = error {
                       print("Erreur lors de la planification de la notification pour \(habit.name): \(error.localizedDescription)")
                   } else {
                       print("Notification pour \(habit.name) planifiée avec succès a lheure de \(habit.timesheet)")
                   }
               }
           }
    
    
    func removeNotifications(for habit: Habit) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.id.uuidString])
        print("La notification a ete supprimé de \(habit.name)")
        }
    
    
    func scheduleNotifications() {
           for habit in habits {
               if habit.notification && habit.status == .toDo {
                   removeNotifications(for: habit)
                   createNotification(for: habit)
               } else {
                   removeNotifications(for: habit)
               }
           }
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
        print(self.history)
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
                removeNotifications(for: habits[index])
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

        if(updatedHabit.status == .done && updatedHabit.quantity > updatedHabit.quantityDone){
            habits[index].status = .toDo
            habits[index].streak -= 1

        
        }
        
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

