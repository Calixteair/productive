//
//  HabitDayView.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import SwiftUI
import UserNotifications



struct HabitDayView: View {
    
    @EnvironmentObject var data: HabitViewModel
    @Namespace var animation
    @State private var showAlert = false
    @State private var habitToDelete: Habit?
    
    
    
    var body: some View {
        NavigationView{
            
            VStack{
                VStack {
                           Button(action: {
                               requestNotificationAuthorization()
                           }) {
                               Text("Demander l'autorisation des notifications")
                           }
                       }
                ScrollView(.horizontal , showsIndicators: false){
                    HStack(spacing: 10){
                        ForEach(data.currentWeek,id: \.self){ day in
                            
                            VStack(spacing: 10){
                                Text(data.extractDate(date: day, format: "dd"))
                                Text(data.extractDate(date: day, format: "EEE"))
                                    .font(.system(size:16))
                                    .fontWeight(.semibold)
                                
                                Circle()
                                    .fill(.white)
                                    .frame(width: 8, height: 8)
                                    .opacity(data.isCurrentDay(date: day) ? 1: 0)
                                
                                
                            }
                            .frame(width: 45, height: 90)
                            .foregroundStyle(data.isCurrentDay(date: day) ? .primary : .secondary)
                            .background(
                            
                                ZStack{
                                    if data.isCurrentDay(date: day){
                                        Capsule()
                                            .fill(Color(red: 1, green: 0.8470, blue: 0.8470))
                                            .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                            
                                    }
                                }
                                
                            )
                            .contentShape(Capsule())
                            .onTapGesture {
                                withAnimation{
                                    data.currentDay = day
                                }
                            }
                                
                            
                        }
                    }
                    .padding(.horizontal)
                }
                
                
                
                List {
                    
                    
                    if let tasks = data.filteredHabits{
                        if tasks.isEmpty{
                            Text("Aucune tache trouvé")
                                .font(.system(size:16))
                                .fontWeight(.light)
                                .offset(y:100)
                            
                        }
                        else{
                            ForEach(tasks) {habit in
                                if habit.status != .suspend {
                                    if data.isToday(date: data.currentDay){
                                        RowView(habit: habit, type: .task)
                                            .onTapGesture {
                                                data.completHabit(habit: habit)
                                                data.filterTodayHabits()
                                                
                                            }
                                            .listRowInsets(EdgeInsets())
                                            .listRowSeparator(.hidden)
                                            .padding(5)
                                    }else {
                                        RowView(habit: habit, type: .task)
                                            .listRowInsets(EdgeInsets())
                                            .listRowSeparator(.hidden)
                                            .padding(5)
                                        
                                    }
                                    
                                    
                                    
                                }
                            }
                            .onDelete { indexSet in
                                if let firstIndex = indexSet.first {
                                    self.habitToDelete = tasks[firstIndex]
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
                .onChange(of: data.currentDay){ newValue in
                    data.filterTodayHabits()
                    
                }
               
            
            }
            .navigationTitle("Habit")
            .listStyle(PlainListStyle())
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    NavigationLink("Modify", destination:ModifyHabitView())
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    NavigationLink("Add", destination: AddHabitView())
                }
            }
            
        }
    }
}
    


func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Autorisation des notifications accordée")
            } else {
                print("Autorisation des notifications refusée")
            }
        }
    }
    
    
    struct HabitDayView_Previews: PreviewProvider {
        static var previews: some View {
            HabitDayView()
                .environmentObject(HabitViewModel())
        }
}

