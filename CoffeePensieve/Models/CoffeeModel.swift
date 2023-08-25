//
//  CoffeeModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/03.
//

import UIKit
import FirebaseFirestoreSwift

// coffee model
struct CoffeeModel {
    let drinkId: String
    let name : String
    let image: String
}

// 서버에서 받아오는 커피 리스트
struct Drink {
    let isIced: Bool
    let drinkId: Int
    let name: String
    let image: String
    
    var drinkImage: UIImage? {
        return UIImage(named: image)
    }
}
