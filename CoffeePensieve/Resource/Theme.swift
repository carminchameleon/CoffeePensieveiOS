//
//  Theme.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/08/02.
//

import UIKit

// 기본적인 색상
enum Theme {
    // background
    static let background = UIColor(named: "background")
    static let detailBackground = UIColor.primaryColor25

    // tint
    static let tintColor = UIColor.primaryColor500
    static let secondaryTintColor = UIColor.primaryColor400

    // black
    static let label = UIColor.label
    static let secondaryLabel = UIColor.secondaryLabel
    
    // red
    static let alert = UIColor.redColor500
    
    
    // 다른색으로 바꿀 수 있으면 바꾸는 걸로
    static let borderPrimary = #colorLiteral(red: 0.6862745098, green: 0.7294117647, blue: 0.7921568627, alpha: 1)
    static let borderSecondary =  #colorLiteral(red: 0.2705882353, green: 0.3294117647, blue: 0.4078431373, alpha: 1)
}


