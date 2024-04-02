//
//  StatView.swift
//  Projethabit
//
//  Created by akburak zekeriya on 29/03/2024.
//

import SwiftUI

struct StatView: View {
    
    @EnvironmentObject var data: HabitViewModel
    @Namespace var animation
    @State private var showAlert = false
    @State private var habitToDelete: Habit?
    
    
    var body: some View {
        NavigationView{
            
            VStack{
                List {
                    
                    
                    if let tasks = data.parsedList {
                        if tasks.isEmpty{
                            Text("Aucune tache trouvé")
                                .font(.system(size:16))
                                .fontWeight(.light)
                                .offset(y:100)
                            
                        }
                        else{
                            ForEach(tasks, id: \.habit.id) { hp in
                                // Utilisez simplement hp.habit car il n'est pas optionnel
                                let habit = hp.habit
                                RowView(habit: habit, type: .statistic, pourcent: hp.pourcent)
                            }
                            .onDelete { indexSet in
                                if let firstIndex = indexSet.first, let tasks = data.parsedList {
                                    self.habitToDelete = tasks[firstIndex].habit
                                    self.showAlert.toggle()
                                }
                            }
                            
                            
                            
                        }
                        
                    }
                    
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Are you sure you want to delete this habit?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let habitToDelete = habitToDelete {
                                print(habitToDelete.name)
                                data.suspendHabit(habit: habitToDelete)
                                data.filterTodayHabits()
                            }
                            self.habitToDelete = nil
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .navigationTitle("Statistiques")
        .listStyle(PlainListStyle())
        
        
        
        
        
        
        
    }
}

struct StatView_Previews: PreviewProvider {
    static var previews: some View {
        StatView()
            .environmentObject(HabitViewModel())
            .onAppear{
                print("stat appear")
                
            }
    }
}
