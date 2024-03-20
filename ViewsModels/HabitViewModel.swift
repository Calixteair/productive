//
//  HabitViewModel.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import Foundation


class HabitViewModel: ObservableObject {
    
    @Published var habits: [Habit] = []
    
    
    init() {
        getHabits()
    }
    
    func getHabits(){
        habits.append(contentsOf: Habit.habitData)
    }
    
    
    func deleteItem(indexSet: IndexSet){
        habits.remove(atOffsets: indexSet)
    }
    
    func moveItem(from: IndexSet, to: Int){
        habits.move(fromOffsets: from, toOffset: to)
    }
    
    func addItem(title: String){
        let newHabit = Habit(name: title,noftification: true,timesheet:"12h32", quantity: 1,quantityDone: 0,status: .toDo, streak: 5, repetition: [.all], unit:"")
        habits.append(newHabit)
    }
    
    func updateItem(habit: Habit){
        for ( index, td) in habits.enumerated(){
            if(td.id == habit.id){
                habits[index].status = .done
            }
        }
    }
}

