//
//  TransactionsContainer.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 8/1/21.
//

import Foundation

final class TransactionsContainer {
    
    private var dayRange: ClosedRange<Date> = Date()...Date()
    private var monthRange: ClosedRange<Date> = Date()...Date()
    private var yearRange: ClosedRange<Date> = Date()...Date()
    
    var todayTransactions = [Transaction]()
    var monthTransactions = [Transaction]()
    var yearTransactions = [Transaction]()
    
    private func updateRanges() {
        let date = Date()
        let components = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: date)
        if  let seconds = components.second,
            let minute = components.minute,
            let hour = components.hour,
            let day = components.day,
            let month = components.month,
            let startDay = Calendar.current.date(byAdding: .second, value: -seconds, to: date),
            let startDay = Calendar.current.date(byAdding: .minute, value: -minute, to: startDay),
            let startDay = Calendar.current.date(byAdding: .hour, value: -hour, to: startDay),
            let startMonth = Calendar.current.date(byAdding: .day, value: -day + 1, to: startDay),
            let startYear = Calendar.current.date(byAdding: .month, value: -month, to: startMonth) {
            dayRange = startDay...Date()
            monthRange = startMonth...Date()
            yearRange = startYear...Date()
        }
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
