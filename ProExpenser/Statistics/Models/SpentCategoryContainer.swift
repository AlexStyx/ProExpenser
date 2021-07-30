//
//  SpentCategoryContainer.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/24/21.
//

import Foundation


final class SpendCategoryContainer {
    
    private let spendCategory: SpendCategory
    private let transactionsContainer: TransactionsContainer?
    private var totalForDay: Double = 0
    private var totalForMonth: Double = 0
    private var totalForYear: Double = 0
    
    var period: Period {
        didSet {
            switch period {
            case .day: total = totalForDay
            case .month: total = totalForMonth
            case .year: total = totalForYear
            }
        }
    }
    
    var transactions: [Transaction]? {
        switch period {
        case .day: return transactionsContainer?.todayTransactions
        case .month: return transactionsContainer?.monthTransactions
        case .year: return transactionsContainer?.yearTransactions
        }
    }
    
    var imageName: String { spendCategory.imageName ?? "" }
    var name: String { spendCategory.name ?? "" }
    
    private(set) var total: Double = 0.0
    
    init(spendCategory: SpendCategory, period: Period) {
        self.spendCategory = spendCategory
        let transactions = spendCategory.transactions?.mutableCopy() as? [Transaction]
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
    
    enum Period {
        case day
        case month
        case year
    }
}
