//
//  ProjethabitApp.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import SwiftUI

@main
struct ProjethabitApp: App {
    var body: some Scene {
        WindowGroup {
            HabitDayView()
                .environmentObject(HabitViewModel())
        }
    }
}
