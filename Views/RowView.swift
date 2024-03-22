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
    
    let pourcent : Double
    
    init(habit: Habit, type: typeRow, pourcent: Double = 0.0) {
          self.habit = habit
          self.type = type
          self.pourcent = pourcent
      }
    
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
        
        if(type == .list){
            ZStack(alignment:.leading){
             
                    
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(red: 1, green: 0.9725, blue: 0.9725))
                        GeometryReader{ proxy in
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(red: 1, green: 0.8470, blue: 0.8470))
                                .frame(width: proxy.size.width * 0.8)
                        }
                    }.frame(height: 80)
                
                    
                HStack{
                    ZStack(alignment: .leading){
                        VStack{
                            HStack{
                                Image(systemName: "bell")
                                    .foregroundColor(.gray)
                                Text("\(habit.getTimeString())")
                                    .foregroundColor(.gray)
                                
                            }.padding([.top, .leading], 6)
                            
                            Spacer()
                        }
                        
                        ZStack{
                            
                            Text(habit.name)
                                .font(.title)
                                .padding()
                        }
                    }
                    Text(habit.repetitionAsString())
                        Spacer()
                    
                    
                        Text("\(habit.quantity)")
                            .font(.title2)
                            .padding(30)
                        
                    
                }
                
                
            }.frame(height: 80)
            
        }
        
        if(type == .statistic){
            ZStack(alignment:.leading){
             
                    
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(red: 1, green: 0.9725, blue: 0.9725))
                        GeometryReader{ proxy in
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(red: 1, green: 0.8470, blue: 0.8470))
                                .frame(width: proxy.size.width * pourcent)
                        }
                    }.frame(height: 80)
                
                    
                HStack{
                    ZStack(alignment: .leading){
                        VStack{
                            HStack{
                                Image(systemName: "bell")
                                    .foregroundColor(.gray)
                                Text("\(habit.getTimeString())")
                                    .foregroundColor(.gray)
                                
                            }.padding([.top, .leading], 6)
                            
                            Spacer()
                        }
                        
                        ZStack{
                            
                            Text(habit.name)
                                .font(.title)
                                .padding()
                        }
                    }
                    Text(habit.repetitionAsString())
                        Spacer()
                    ZStack(alignment:.trailing){
                        VStack{
                            if habit.streak > 0{
                                Text("🔥 \(habit.streak) Days")
                                    .padding(5)
                                
                                Spacer()
                                
                            }
                        }
                        
                        Text("\(Int(pourcent*100))%")
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
        RowView(habit: Habit.habitData[0] , type:.statistic,pourcent:0.8)
    }
}
