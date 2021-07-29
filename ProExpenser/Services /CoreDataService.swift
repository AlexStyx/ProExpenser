//
//  CoreDataService.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/24/21.
//

import Foundation
import UIKit
import CoreData

protocol CoreDataServiceProtocol {
    func addCategory(name: String, imageName: String)
    func addTransaction(for category: SpendCategory, date: Date, transitedValue: Double)
    func getCategories() -> [SpendCategory]?
    func getTransactions(for category: SpendCategory) -> [Transaction]?
    func loadDataFromPropertyList()
}

final class CoreDataService: CoreDataServiceProtocol {
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func addCategory(name: String, imageName: String) {
        let entity = createEntity(entityKind: EntityKind.spendCategory)
        let category = SpendCategory(entity: entity, insertInto: context)
        category.name = name
        category.imageName = imageName
        saveContext()
    }
    
    func addTransaction(for category: SpendCategory, date: Date, transitedValue: Double) {
        guard let transactions = category.transactions?.mutableCopy() as? NSMutableOrderedSet else { fatalError("Error gettind SpendCategory data in addTransaction(for category: SpendCategory, date: Date, transitedValue: Double) ") }
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
        var transactions = [Transaction]()
        for transaction in category.transactions ?? NSMutableOrderedSet() {
            if let transaction = transaction as? Transaction {
                transactions.append(transaction)
            }
        }
        return transactions
    }
    
    func loadDataFromPropertyList() {
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "alreadyLogined") != true {
            guard
                let path = Bundle.main.path(forResource: "SpendCategories", ofType: "plist"),
                let dataArray = NSArray(contentsOfFile: path)
            else {
                print("")
                return
            }
            for dictionary in dataArray {
                let entity = createEntity(entityKind: .spendCategory)
                let spendItemDictionary = dictionary as! [String: Any]
                let spendCategory = SpendCategory(entity: entity, insertInto: context)
                spendCategory.imageName = spendItemDictionary["imageName"] as? String
                spendCategory.name = spendItemDictionary["name"] as? String
            }
            saveContext()
            userDefaults.setValue(true, forKey: "alreadyLogined")
        }
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
            print(context)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
