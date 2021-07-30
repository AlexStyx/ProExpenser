//
//  EnterRouter.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/25/21.
//

import Foundation

protocol EnterRouterProtocol {
    func goToChart()
}

class EnterRouter: EnterRouterProtocol {
    weak var viewController: EnterAmountViewController!
    
    init(viewController: EnterAmountViewController) {
        self.viewController = viewController
    }
    
    func goToChart() {
        print(#function)
    }
}
