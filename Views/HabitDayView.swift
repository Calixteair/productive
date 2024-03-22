//
//  HabitDayView.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import SwiftUI



struct HabitDayView: View {
    
    @EnvironmentObject var data: HabitViewModel
    @State private var showAlert = false
    @State private var habitToDelete: Habit?
    
    
    var body: some View {
        NavigationView{
            List {
                ForEach(data.habits) {habit in
                    if habit.status != .suspend {
                        RowView(habit: habit, type: .task)
                            .onTapGesture {
                                data.completHabit(habit: habit)
                            }
                    }
                }
                .onDelete { indexSet in
                    if let firstIndex = indexSet.first {
                        self.habitToDelete = data.habits[firstIndex]
                        self.showAlert.toggle()
                    }
                }
                .onMove(perform: data.moveItem)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Confirmation"),
                    message: Text("Are you sure you want to delete this habit?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let habitToDelete = habitToDelete {
                            data.suspendHabit(habit: habitToDelete)
                            }
                            self.habitToDelete = nil
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle("Habit")
            .listStyle(PlainListStyle())
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    NavigationLink("Add", destination: AddHabitView())
                }
            }
            
        }
    }
}
    
    
    
    struct HabitDayView_Previews: PreviewProvider {
        static var previews: some View {
            HabitDayView()
                .environmentObject(HabitViewModel())
        }
}

