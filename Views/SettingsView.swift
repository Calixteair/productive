//
//  SettingsView.swift
//  Projethabit
//
//  Created by akburak zekeriya on 29/03/2024.
//
import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") var notificationsEnabled = true
    @AppStorage("isDarkMode") var isDarkMode = false

    var body: some View {
        Form {
            Section(header: Text("Notifications")) {
                Toggle("Activer les notifications", isOn: $notificationsEnabled)
            }
            Section(header: Text("Apparence")) {
                Toggle("Mode sombre", isOn: $isDarkMode)
            }
        }
        .navigationBarTitle("Réglages")
    }
}
