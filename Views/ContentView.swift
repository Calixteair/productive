//
//  ContentView.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import SwiftUI

struct ContentView: View {
    
    
    @EnvironmentObject var habitViewModel: HabitViewModel
    @AppStorage("isDarkMode") var isDarkMode = true

    var body: some View {
        
        TabView{
            HabitDayView().tabItem{Label("",systemImage:"list.bullet.clipboard")}
            StatView().tabItem{Label("",systemImage: "chart.line.uptrend.xyaxis")}
                .onAppear(){
                    print("tap stat")
                    habitViewModel.parseedHistodata()
                }
            
            SettingsView().tabItem{Label("",systemImage: "gear")}


        }.preferredColorScheme(isDarkMode ? .dark : .light)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(HabitViewModel())
            
    }
}

