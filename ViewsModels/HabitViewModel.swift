 //
//  HabitViewModel.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import Foundation
import UserNotifications
import SwiftUI


struct habitandpourcent{
    var habit: Habit
    var pourcent : Double

}


class HabitViewModel: ObservableObject {
    
    @Published var habits: [Habit] = []
    
    @Published var currentWeek: [Date] = []
    
    @Published var currentDay: Date = Date()
    
    @Published var filteredHabits: [Habit]?
    
    @Published var history: LisHistory = LisHistory.histoData

     @Published var parsedList: [habitandpourcent]?
    
    
    @AppStorage("notificationsEnabled") var notificationsEnabled = true

    
    
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
               if habit.notification && habit.status == .toDo && notificationsEnabled{
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
    func filterTodayHabits() {
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            
            if calendar.isDateInToday(self.currentDay) {
                let filtered = self.habits.filter { habit in
                    return habit.repetition.contains { $0.rawValue == self.weekdayToDayString(calendar.component(.weekday, from: self.currentDay)) }
                }
                
                DispatchQueue.main.async {
                    self.filteredHabits = filtered
                }
            } else if self.currentDay > Date() {
                // Le jour actuel est dans le futur, filtrez à partir des habitudes
                let filtered = self.habits.filter { habit in
                    return habit.repetition.contains { $0.rawValue == self.weekdayToDayString(calendar.component(.weekday, from: self.currentDay)) }
                }

                let filteredWithNewProperties = filtered.map { habit in
                    return Habit(id: UUID(), name: habit.name, notification: false, timesheet: Date(), quantity: habit.quantity, quantityDone: 0, status: .toDo, streak: 0, repetition: habit.repetition, unit: habit.unit)
                }

                DispatchQueue.main.async {
                    self.filteredHabits = filteredWithNewProperties
                }
            } else {
                // Le jour actuel est dans le passé, filtrez à partir de l'historique
                let filteredHistoryItems = self.history.items.filter { item in
                    return calendar.isDate(item.date, inSameDayAs: self.currentDay)
                }

                let pastHabits = filteredHistoryItems.compactMap { item in
                    let habit = self.habits.first { $0.id == item.idHabit }
                    return habit.map { h in
                        return Habit(id: UUID(), name: h.name, notification: false, timesheet: item.date, quantity: h.quantity, quantityDone: item.status == .toDo ? 0 : h.quantity, status: item.status, streak: item.streak, repetition: h.repetition, unit: h.unit)
                    }
                }

                DispatchQueue.main.async {
                    self.filteredHabits = pastHabits
                }

                
               
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
                        self.history.items.append(item)
                    }
                }
                
            }
            
        }
        print(self.history.printHistory())
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
        let habitinfo = habits[id]
        let finishhabit = ItemHistory(idHabit: habitinfo.id, streak: habitinfo.streak+1, date: Date(), status: .done)
        history.items.append(finishhabit)
        print("add in history")
        
    }
    
    func updateItem(habit: Habit){
        for ( index, td) in habits.enumerated(){
            if(td.id == habit.id){
                habits[index].status = .done
                
                
            }
        }
    }

     func parseedHistodata() {
            // Vérifiez si history.items est vide
            guard !habits.isEmpty else {
                print("No items in history")
                return
            }

        parsedList = []

            // Créez un ensemble pour stocker les idHabit uniques
            var uniqueIdHabits = Set<UUID>()

            // Parcourir chaque élément et ajouter son idHabit à l'ensemble
            for item in habits {
                uniqueIdHabits.insert(item.id)
            }

            // Imprimer chaque idHabit unique
            for idHabit in uniqueIdHabits {
                if let habit = getHabitByuuid(UUID: idHabit) {
                    let pourcent = pourcentageCalculation(UUID: idHabit)
                    let hp = habitandpourcent(habit: habit, pourcent: pourcent)
                    parsedList?.append(hp)
                } else {
                    print("Habit not found for UUID: \(idHabit)")
                }
            }
        }

        func nameprint(habit : Habit){
            print(habit.name)
        }


    func pourcentageCalculation(UUID: UUID) -> Double {
        var tot: Double = 0
        var dotask: Double = 0

        // Parcourir chaque élément de l'historique
        print(history.items)
        print(history.items.count)
        for item in history.items {
            // Vérifier si l'ID de l'habitude correspond à l'UUID spécifié
            if item.idHabit == UUID {
                tot += 1
                print("plus 1")
                // Si la tâche est effectuée, incrémente dotask
                if item.status == .done {
                    dotask += 1
                }
            }
        }
        print("pourcent : " , (dotask / tot))
        // Calculer le pourcentage
        if tot == 0 {
            // Si aucune tâche n'a été effectuée pour cette habitude, retourner 0
            return 0
        } else {
            // Retourner le pourcentage de tâches effectuées par rapport au total des tâches
            return (dotask / tot)
        }
    }


        // Fonction getHabitByuuid pour récupérer l'habitude en fonction de son UUID
        func getHabitByuuid(UUID: UUID) -> Habit? {
            // Implémentez votre logique pour rechercher l'habitude par son UUID dans la liste appropriée
            // et retournez l'habitude si trouvée, sinon retournez nil
            // Exemple hypothétique:
            for habit in habits {
                if habit.id == UUID {
                    return habit
                }
            }
            return nil
        }
}

