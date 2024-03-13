//
//  ContentView.swift
//  Projethabit
//
//  Created by reymond calixte on 13/03/2024.
//

import SwiftUI

struct TodoListView: View {
    
    @EnvironmentObject var data: TodoViewModel
    
    var body: some View {
        NavigationView{
            List{
                ForEach(data.todos) { todo in
                    RowView(todo: todo)
                        .onTapGesture {
                            data.updateItem(todo: todo)
                        }
                }
                .onDelete(perform: data.deleteItem)
                .onMove(perform: data.moveItem)
            }
            .navigationTitle("Todo")
            .listStyle(PlainListStyle())
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    NavigationLink("Add", destination: AddTodoView())
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
            .environmentObject(TodoViewModel())
            
    }
}
