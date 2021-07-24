//
//  CoreDataService.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/24/21.
//

import Foundation
import UIKit
import CoreData

final class CoreDataService {
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func addCategory(name: String, imageName: String) {
        let entity = createEntity(entityKind: EntityKind.spendCategory)
        let category = SpendCategory(entity: entity, insertInto: context)
        category.name = name
        category.imageName = imageName
        saveContext()
    }
    
    func addTransaction(for category: SpendCategory, date: Date, transitedValue: Double) {
        guard let transactions = category.transactions?.mutableCopy() as? NSMutableOrderedSet else { return }
        let entity = createEntity(entityKind: EntityKind.transaction)
        let transaction = Transaction(entity: entity, insertInto: context)
        transaction.date = date
        transaction.transitedValue = transitedValue
        transactions.add(transaction)
        category.transactions = transactions
        saveContext()
    }
    
    func getCategories() -> [SpendCategory]? {
        let fetchRequest: NSFetchRequest<SpendCategory> = SpendCategory.fetchRequest()
        return try? context?.fetch(fetchRequest)
    }
    
    func getTransactions(for category: SpendCategory) -> [Transaction]? {
        return category.transactions?.mutableCopy() as? [Transaction]
    }
    
    private func createEntity(entityKind: EntityKind) -> NSEntityDescription {
        guard
            let context = context,
            let entity = NSEntityDescription.entity(forEntityName: entityKind.rawValue, in: context)
        else {
            fatalError("Cannot found context or entity")
        }
        return entity
    }
    
    private func saveContext() {
        do {
            try context?.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
}
