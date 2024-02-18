// Created by deovinsum

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var currency: Currency = .RUB
    
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                Picker("Currency", selection: $currency) {
                    ForEach(Currency.allCases, id: \.self) { curr in
                        Text(curr.rawValue)
                    }
                }
                
                
                
                TextField("Amount", value: $amount, format: .currency(code: currency.rawValue))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add New Expense")
            .toolbar {
                Button("Save") {
                    let newItem = ExpenseItem(name: name, type: type, amount: amount, currency: currency)
                    expenses.items.append(newItem)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
