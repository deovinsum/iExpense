// Created by deovinsum

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var title = "New Expense"
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var currency: Currency = .RUB
    
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                
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
            .navigationTitle($title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newItem = ExpenseItem(title: title, type: type, amount: amount, currency: currency)
                        expenses.items.append(newItem)
                        dismiss()
                    }
                    }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    AddView(expenses: Expenses())
}
