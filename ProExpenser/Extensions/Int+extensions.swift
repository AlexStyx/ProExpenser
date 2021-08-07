//
//  Int+extension.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 8/6/21.
//

import Foundation

extension Int {
    var arc4random: Int {
        if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
