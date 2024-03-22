//
//  AddHabitView.swift
//  Projethabit
//
//  Created by reymond calixte on 20/03/2024.
//

import SwiftUI

struct AddHabitView: View {
    

    
    @State var habitName: String = ""
    @State var noftification: Bool = false
    @State var timesheet = Date()
    @State var quantity = 1
    @State var quantityDone: Int = 0
    @State var status: Status = .toDo
    @State var streak: Int = 0
    @State var repetition: [Day] = []
    @State private var selectedDays: Set<Day> = []
    @State private var showList = false
    @State private var unit: String = ""
    
    
    
    
    
    
    
    @EnvironmentObject var data: HabitViewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        VStack(spacing: 16){
            TextField("Enter your habit", text: $habitName)
                .padding(.horizontal)
                .frame(height: 55)
                .background(Color(.systemGray4))
                .cornerRadius(10)
            
            Button(action: {
                self.showList.toggle()
            }) {
                Text("Select Days")
            }
            if showList {
                List {
                    ForEach(Day.allCases, id: \.self) { day in
                        MultipleSelectionRow(day: day, isSelected: self.selectedDays.contains(day)) {
                            if self.selectedDays.contains(day) {
                                self.selectedDays.remove(day)
                            } else {
                                self.selectedDays.insert(day)
                            }
                        }
                    }
                }
                	
            }
            Toggle(isOn: $noftification) {
                Text("Enable Notification")
            }
            .padding(.horizontal)
            
            HStack {
                Text("Select Time:")
                Spacer()
                DatePicker("", selection: $timesheet, displayedComponents: .hourAndMinute)
                    .labelsHidden()
            }
            .padding(.horizontal)
            
            
            TextField("Quantity", value: $quantity, formatter: NumberFormatter())
                .padding(.horizontal)
                .frame(height: 55)
                .background(Color(.systemGray4))
                .cornerRadius(10)
                .keyboardType(.numberPad)
            
            
            TextField("unit (optional)", text: $unit)
            

            
            Button{
                presentationMode.wrappedValue.dismiss()
                data.addItem(title: habitName, notification: noftification, timesheet: timesheet, quantity: quantity, repetition: repetition, unit: unit)
                
            } label: {
                Text("Save")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding(14)
        .navigationTitle("Add a habit")
    }
}

struct MultipleSelectionRow: View {
    var day: Day
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: {
            self.action()
        }) {
            HStack {
                Text(day.rawValue)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}


struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AddHabitView()
        }
        
    }
}
