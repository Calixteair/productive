//
//  HabitDayView.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import SwiftUI



struct HabitDayView: View {
    
    @EnvironmentObject var data: HabitViewModel
    
    
    var body: some View {
        NavigationView{
            List{
                ForEach(data.habits) {_ in Text("test")
                }
                .onDelete(perform: data.deleteItem)
                .onMove(perform: data.moveItem)
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

