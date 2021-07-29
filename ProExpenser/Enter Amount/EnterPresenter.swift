//
//  EnterPresenter.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/25/21.
//

import Foundation

protocol EnterPresenterProtocol: AnyObject {
    var router: EnterRouterProtocol! { get set }
    func configureView()
    func collectionViewCellClicked(at indexPath: IndexPath)
    func goToChartButtonClicked()
    func handleInputValue(handledValue: String?)
    func numberOfCells() -> Int
    func category(at indexPath: IndexPath) -> SpendCategory?
    func numberOfRows() -> Int
    func transaction(at indexPath: IndexPath) -> Transaction
}

class EnterPresenter: EnterPresenterProtocol {
    weak var view: EnterViewProtocol!
    var router: EnterRouterProtocol!
    var interactor: EnterInteractorProtocol!
    
    private var defaultAmountValue = "Enter amount"
    private let maxAmountLength = 12
    private lazy var inputValue: String =  defaultAmountValue
    
    //MARK: - Configure collcationView
    func numberOfCells() -> Int {
        interactor.categories.count
    }
    
    func category(at indexPath: IndexPath) -> SpendCategory? {
        let index = indexPath.row
        return interactor.category(at: index)
    }
    
    //MARK: - Configure tableView
    func numberOfRows() -> Int {
        interactor.todayTransctions.count
    }
    
    func transaction(at indexPath: IndexPath) -> Transaction {
        let index = indexPath.row
        return interactor.transaction(at: index)
    }
    
    //MARK: - Hanlde actions
    func handleInputValue(handledValue: String?) {
        if let handledValue = handledValue {
            inputValue = validate(handledValue: handledValue)
        } else {
            if inputValue.count == 1 {
                inputValue = defaultAmountValue
            } else {
                inputValue.removeLast()
            }
        }
        updateView()
    }
    
    func goToChartButtonClicked() {
        router.goToChart()
    }
    
    func collectionViewCellClicked(at indexPath: IndexPath) {
        guard inputValue != defaultAmountValue else { return }
        interactor.amount = Double(inputValue) ?? nil
        let index = indexPath.row
        interactor.saveTransaction(to: index)
    }
    
    //MARK: - Validation
    private func validate(handledValue: String) -> String  {
        var validatedString = inputValue
        if validatedString.count <= maxAmountLength {
            if handledValue == "." {
                if validatedString.filter({ $0 == "." }).count < 1 && handledValue == ".",
                   validatedString != defaultAmountValue,
                   validatedString.count < maxAmountLength {
                    print(handledValue)
                    validatedString += handledValue
                }
            } else {
                if validatedString == defaultAmountValue {
                    validatedString = ""
                }
                validatedString += handledValue
            }
        }
        
        if let dotIndex = validatedString.firstIndex(of: ".") {
            if validatedString[dotIndex..<validatedString.endIndex].count == 3,
               let value = Double(validatedString) {
                validatedString = String(format: "%.2f", value)
            } else if validatedString[dotIndex..<validatedString.endIndex].count >= 3 {
                validatedString.removeLast()
            }
        }
        
        if validatedString.first == "0" {
            let indexOfTheNextElement = validatedString.index(validatedString.startIndex, offsetBy: 1)
            if validatedString.count >= 2,
               validatedString[indexOfTheNextElement] != "." {
                validatedString.removeLast()
            }
        }
        
        return validatedString
    }
    
    
    //MARK: - Configure and update view
    private func updateView() {
        view.updateEnterAmountLabelValue(newValue: inputValue)
        view.updateLists()
    }
    
    func configureView() {
        view.setupNavigationController()
        view.addSubviews()
        view.setupLayout()
    }
    
    required init(view: EnterViewProtocol) {
        self.view = view
    }
}
