//
//  CustomExpenseListView.swift
//  iExpense
//
//  Created by 이찬희 on 2/15/24.
//

import SwiftUI
//ContentView에서 리스트
struct CustonExpenseListView: View {
    // Expenses를 받아와야 함
    var expenses: Expenses
    
    var body: some View {
        ForEach(expenses.items) { item in
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text(item.type)
                }    //VStack
                Spacer()
                Text(item.amount, format: .currency(code: item.code))
                    .foregroundStyle(changeTextColorByAmount(amount: item.amount))
            }    //HStack
        }    //ForEach
        .onDelete(perform: removeItems)
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func changeTextColorByAmount(amount: Double) -> Color {
        if amount < 10 {
            return .red
        } else if amount < 100 {
             return .green
         }
        return .blue
    }
}    //struct

#Preview {
    CustonExpenseListView(expenses: Expenses(key: ""))
}
