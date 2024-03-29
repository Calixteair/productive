//
//  ContentView.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView{
            
            StatView().tabItem{Label("",systemImage: "chart.line.uptrend.xyaxis")}
            HabitDayView().tabItem{Label("",systemImage:"list.bullet.clipboard")}
            SettingsView().tabItem{Label("",systemImage: "gear")}
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

