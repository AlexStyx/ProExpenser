//
//  EnterConfigurator.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/25/21.
//

import Foundation

protocol EnterConfiguratorProtocol {
    func configure(with viewController: EnterAmountViewController)
}

class EnterConfigurator: EnterConfiguratorProtocol {
    func configure(with viewController: EnterAmountViewController) {
        let presenter = EnterPresenter(view: viewController)
        let interactor = EnterInteractor(presenter: presenter)
        let router = EnterRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
