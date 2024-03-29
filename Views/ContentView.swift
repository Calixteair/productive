//
//  ContentView.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import SwiftUI

struct ContentView: View {
    
    
    @EnvironmentObject var habitViewModel: HabitViewModel
    var body: some View {
        
        TabView{
            HabitDayView().tabItem{Label("",systemImage:"list.bullet.clipboard")}
            StatView().tabItem{Label("",systemImage: "chart.line.uptrend.xyaxis")}
                .onAppear(){
                    print("tap stat")
                }
            
            SettingsView().tabItem{Label("",systemImage: "gear")}


        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(HabitViewModel())
            
    }
}

