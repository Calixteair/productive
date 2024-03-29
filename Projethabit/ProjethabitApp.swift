//
//  ProjethabitApp.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import SwiftUI

@main
struct ProjethabitApp: App {
    // Créez une clé pour stocker l'historique dans AppStorage
    private let historyKey = "historyData"
    

    
    // Créez une instance de HabitViewModel
    @StateObject var habitViewModel = HabitViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(HabitViewModel())
            
        }
    }
}
