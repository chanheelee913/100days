//
//  ContentView.swift
//  iExpense
//
//  Created by 이찬희 on 1/24/24.
//

import SwiftUI

struct ContentView: View {
    //Personal expenses 요소들을 저장할 배열 인스턴스를 선언
    @State private var personalExpenses = Expenses(key: "p_items")
    //Business expenses 요소들을 저장할 배열 인스턴스를 선언
    @State private var businessExpenses = Expenses(key: "b_items")
    
    //새로운 expense를 추가하는 AddView를 띄우기 위한 프로퍼티
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    CustonExpenseListView(expenses: personalExpenses)
                }    //Personal Section
                Section("Business") {
                    CustonExpenseListView(expenses: businessExpenses)
                }
            }    //List
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add expense", systemImage: "plus") {
                    showingAddExpense = true
            }
        }    //NavigationStack
        .sheet(isPresented: $showingAddExpense) {
            AddView(personalExpenses: personalExpenses, businessExpenses: businessExpenses)
        }
        }
    }
}    //ContentView

#Preview {
    ContentView()
}
