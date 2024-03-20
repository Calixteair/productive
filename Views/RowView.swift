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
    
    var body: some View {
        if(type == .task){
            ZStack{
                RoundedRectangle(cornerRadius: 40)
                
                
            }
        }
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(habit: Habit.habitData[0] , type:.task)
    }
}
