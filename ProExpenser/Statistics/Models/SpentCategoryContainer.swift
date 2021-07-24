//
//  SpentCategoryContainer.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/24/21.
//

import Foundation

class SpendCategoryContainer {
    private let spendCategory: SpendCategory
    private let transactionsContainer: TransactionsContainer?
    private var totalForDay: Double = 0
    private var totalForMonth: Double = 0
    private var totalForYear: Double = 0
    
    var period: Calendar.Component {
        didSet {
            switch period {
            case .day: total = totalForDay
            case .month: total = totalForMonth
            case .year: total = totalForYear
            default: break
            }
        }
    }
    
    var total: Double = 0.0
    
    init(spendCategory: SpendCategory, period: Calendar.Component) {
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
}
