//
//  RowView.swift
//  Projethabit
//
//  Created by akburak zekeriya on 13/03/2024.
//

import SwiftUI

struct RowView: View {
    
    let habit : Habit
    
    let type : typeRow
    
    var progressHabit: Double{
        return (CGFloat(habit.quantityDone) / CGFloat(habit.quantity) )
    }
    
    var body: some View {
        if(type == .task){
                ZStack(alignment:.leading){
                 
                        
                        ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(red: 1, green: 0.9725, blue: 0.9725))
                            GeometryReader{ proxy in
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(red: 1, green: 0.8470, blue: 0.8470))
                                    .frame(width: proxy.size.width * progressHabit)
                            }
                        }.frame(height: 80)
                    
                        
                    HStack{
                        Text(habit.name)
                            .font(.title)
                            .padding()
                        Spacer()
                        ZStack(alignment:.trailing){
                            VStack{
                                if habit.streak > 0{
                                    Text("🔥 \(habit.streak) Days")
                                        .padding(5)
                                    
                                    Spacer()
                                    
                                }
                            }
                            
                            Text("\(habit.quantityDone)/\(habit.quantity)")
                                .font(.title2)
                                .padding()
                            Spacer()
                            
                        }
                    }
                    
                    
                    
                    
                    
                }.frame(height: 80)
            
        }
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(habit: Habit.habitData[0] , type:.task)
    }
}
