//
//  TransactionsContainer.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/24/21.
//

import Foundation

final class TransactionsContainer {
    
    private var dayRange: ClosedRange<Date> = (Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())...Date()
    private var monthRange: ClosedRange<Date> = (Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date())...Date()
    private var yearRange: ClosedRange<Date> = (Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date())...Date()
    
    var todayTransactions = [Transaction]()
    var monthTransactions = [Transaction]()
    var yearTransactions = [Transaction]()
    
    private func updateRanges() {
        dayRange = (Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())...Date()
        monthRange = (Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date())...Date()
        yearRange = (Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date())...Date()
    }
    
    private func updateTransactionLists(transactions: [Transaction]) {
        todayTransactions = transactions.filter { $0.date != nil ? dayRange.contains($0.date!) : false }
        monthTransactions = transactions.filter { $0.date != nil ? monthRange.contains($0.date!) : false }
        yearTransactions = transactions.filter { $0.date != nil ? yearRange.contains($0.date!) : false }
    }
    
    init?(transactions: [Transaction]?) {
        guard  let transactions = transactions else { return nil }
        updateRanges()
        updateTransactionLists(transactions: transactions)
    }
}
