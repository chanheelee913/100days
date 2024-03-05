//
//  AddView.swift
//  iExpense
//
//  Created by 이찬희 on 2/7/24.
//


import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var code = "USD"
    
    //code의 종류를 선언
    let codes = ["USD", "KRW", "JPY", "CNY", "EUR"]

    
    //type의 종류를 선언
    let types = ["Business", "Personal"]
    
        
    
    //ContentView로 돌아가기 위해 환경에서 dismiss를 가져옴
    @Environment(\.dismiss) var dismiss
    
    //
    var personalExpenses: Expenses
    var businessExpenses: Expenses
    
    
    
    var body: some View {
        NavigationStack {
            Form {
                //expense 이름을 입력하는 텍스트 필드
                TextField("Name", text: $name)
                
                //expense 종류를 선택하는 피커
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }    //Picker
                
                //통화 코드를 선택하는 피커
                Picker("Code", selection: $code) {
                    ForEach(codes, id:\.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                
                TextField("Amount", value: $amount, format: .currency(code: code))
                                    
            }    //Form
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    //추가할 아이템을 생성
                    let item = ExpenseItem(name: name, type: type, amount: amount, code: code)
                    //배열에 아이템을 추가
                    //expenses.items.append(item)
                    item.type == "Personal" ?
                    personalExpenses.items.append(item): businessExpenses.items.append(item)
                    print("\(item.type) expenses 배열에 아이템 추가")
                    //이전으로 되돌아감
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView(personalExpenses:Expenses(key: "p_items"), businessExpenses: Expenses(key: "b_items"))
}
