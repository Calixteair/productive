//
//  EditHabitView.swift
//  Projethabit
//
//  Created by akburak zekeriya on 26/03/2024.
//

import SwiftUI

struct EditHabitView: View {
        @State var habitName: String
      @State var notification: Bool
      @State var timesheet: Date
      @State var quantity: Int
      @State private var selectedDays: Set<Day>
      @State private var showList = false
      @State private var unit: String
    
    @State var habitEdit: Habit

    
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var data: HabitViewModel

    
    
    init(habit: Habit) {
            _habitName = State(initialValue: habit.name)
            _notification = State(initialValue: habit.notification)
            _timesheet = State(initialValue: habit.timesheet)
            _quantity = State(initialValue: habit.quantity)
            _selectedDays = State(initialValue: Set(habit.repetition))
            _unit = State(initialValue: habit.unit)
            _habitEdit = State(initialValue: habit)
        }
    
    
    
    var body: some View {
        VStack{
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
            Toggle(isOn: $notification) {
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


                habitEdit.updateHabit(name: habitName,notification: notification, timesheet: timesheet,quantity: quantity,repetition: Array(selectedDays),unit: unit)

                data.updateHabit(updatedHabit: habitEdit)
                data.scheduleNotifications()

                
                
                
                
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
    }
}

struct EditHabitView_Previews: PreviewProvider {
    static var previews: some View {
        EditHabitView(habit: Habit.habitData[0])
    }
}
