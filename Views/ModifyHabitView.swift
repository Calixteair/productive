//
//  ModifyHabitView.swift
//  Projethabit
//
//  Created by akburak zekeriya on 26/03/2024.
//

import SwiftUI

struct ModifyHabitView: View {
    @EnvironmentObject var data: HabitViewModel
    @State private var habitToDelete: Habit?


    var body: some View {
      
        VStack{
            
            List{
                
                ForEach(data.habits) {habit in
                    if habit.status != .suspend {
                        NavigationLink(destination: EditHabitView(habit: habit)){
                            RowView(habit: habit, type: .list)
                                
                        }.listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .padding(5)
                    }
                    
                }
                .onDelete { indexSet in
                    if let firstIndex = indexSet.first {
                        data.suspendHabit(habit:  data.habits[firstIndex])
                        
                    }
                }
                
                
            }
            .listStyle(PlainListStyle())
            
            
            Button(action: data.printAllHabitsDetails){
                Text("gfryf")
            }
            
        }.navigationTitle("Modify")

        
        
        
        
        
        
        
        
    }
}

struct ModifyHabitView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyHabitView().environmentObject(HabitViewModel())
    }
}
