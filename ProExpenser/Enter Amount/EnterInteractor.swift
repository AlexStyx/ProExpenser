//
//  EnterInteractor.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/25/21.
//

import Foundation

protocol EnterInteractorProtocol {
    var amount: Double? { get set }
    var categories: [SpendCategory] { get }
    var todayTransctions: [Transaction] { get }
    func saveTransaction(to index: Int)
    func transaction(at index: Int) -> Transaction
    func category(at index: Int) -> SpendCategory
}

class EnterInteractor: EnterInteractorProtocol {
    weak var presenter: EnterPresenterProtocol!
    let coreDataService: CoreDataServiceProtocol = CoreDataService()
    var amount: Double?
    
    var categories: [SpendCategory] {
        coreDataService.getCategories() ?? []
    }
    
    var todayTransctions: [Transaction] {
        let dateRange: ClosedRange<Date>  = Calendar.current.date(byAdding: .day, value: -1, to: Date())!...Date()
        var transactions = [Transaction]()
        for category in categories {
            transactions += coreDataService.getTransactions(for: category)?.filter{ dateRange.contains($0.date!) } ?? []
        }
        return transactions.sorted { $0.date! < $1.date! }
    }
    
    func saveTransaction(to index: Int) {
        guard let amount = amount else { return }
        let spentCategory = categories[index]
        coreDataService.addTransaction(for: spentCategory, date: Date(), transitedValue: amount)
    }
    
    func transaction(at index: Int) -> Transaction {
        todayTransctions[index]
    }
    
    func category(at index: Int) -> SpendCategory {
        categories[index]
    }
    
    required init(presenter: EnterPresenterProtocol) {
        self.presenter = presenter
        coreDataService.loadDataFromPropertyList()
    }
}
