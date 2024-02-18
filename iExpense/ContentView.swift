// Created by deovinsum

import SwiftUI

enum Currency: String, Codable, CaseIterable { // for fun and practice protocols
    case RUB, EUR, USD, GBP
}

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    let currency: Currency
}

@Observable
class Expenses {
    var items: [ExpenseItem] = [] {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(expenses.items.filter { $0.type == "Personal"} ) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: item.currency.rawValue))
                                .foregroundStyle(selectColor(amount: item.amount))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                
                Section("Business") {
                    ForEach(expenses.items.filter { $0.type == "Business"} ) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: item.currency.rawValue))
                                .foregroundStyle(selectColor(amount: item.amount))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func selectColor(amount: Double) -> Color {
        switch amount {
        case 10..<100:
                .blue
        case 100...:
                .red
        default:
                .black
        }
    }
}

    
    #Preview {
        ContentView()
    }
