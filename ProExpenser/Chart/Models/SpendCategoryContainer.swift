//
//  SpendCategoryContainer.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 8/1/21.
//

import Foundation


final class SpendCategoryContainer {
    
    private let spendCategory: SpendCategory
    private let transactionsContainer: TransactionsContainer?
    private var totalForDay: Double = 0
    private var totalForMonth: Double = 0
    private var totalForYear: Double = 0
    private let coreDataService = CoreDataService()
    
    var period: Period
    
    var transactions: [Transaction]? {
        switch period {
        case .day: return transactionsContainer?.todayTransactions
        case .month: return transactionsContainer?.monthTransactions
        case .year: return transactionsContainer?.yearTransactions
        }
    }
    
    var imageName: String { spendCategory.imageName ?? "" }
    var name: String { spendCategory.name ?? "" }
    
    var total: Double {
        switch period {
        case .day: return totalForDay
        case .month: return totalForMonth
        case .year: return totalForYear
        }
    }
    
    init(spendCategory: SpendCategory, period: Period) {
        self.spendCategory = spendCategory
        let transactions = coreDataService.getTransactions(for: spendCategory)
        self.transactionsContainer = TransactionsContainer(transactions: transactions)
        self.period = period
        updateTotal()
    }
    
    private func updateTotal() {
        guard let transactionsContainer = transactionsContainer else { return }
        
        totalForDay = transactionsContainer.todayTransactions.reduce(0.0, { total, transaction in
            total + transaction.transitedValue
        })
        
        totalForMonth = transactionsContainer.monthTransactions.reduce(0.0, { total, transaction in
            total + transaction.transitedValue
        })
        
        totalForYear = transactionsContainer.yearTransactions.reduce(0.0, { total, transiction in
            total + transiction.transitedValue
        })
    }
    enum Period: String, CaseIterable, Identifiable {
        case day
        case month
        case year
        
        var id: String { self.rawValue }
    }
}
