//
//  EnterRouter.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/25/21.
//

import SwiftUI
import UIKit

protocol EnterRouterProtocol {
    func goToChart()
}

class EnterRouter: EnterRouterProtocol {
    weak var viewController: EnterAmountViewController!
    
    init(viewController: EnterAmountViewController) {
        self.viewController = viewController
    }
    
    func goToChart() {
        let pieChart = PieChartView()
        let rootViewController = UIHostingController(rootView: pieChart)
        viewController.present(rootViewController, animated: true)
    }
}
