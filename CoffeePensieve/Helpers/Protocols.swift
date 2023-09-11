//
//  Protocols.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/11.
//

import Foundation

@objc protocol AutoLayoutable {
    @objc optional func setBackgroundColor()
    func setupAutolayout()
}
