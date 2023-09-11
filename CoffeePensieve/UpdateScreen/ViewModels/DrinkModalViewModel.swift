//
//  DrinkViewModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/11.
//

import UIKit
// TODO: - 제일 많이 마신 음료를 initial Row에 넣어도 괜찮을 것 같음.
final class DrinkModalViewModel {
    
    var drinkList: [Drink] {
        return Constant.drinkList.sorted { $0.drinkId < $1.drinkId }
    }
    var selectedDrinkId = 0
    var selectedDrinkHandler: (Drink) -> Void

    init(drinkId: Int?, selectEventHandler: @escaping ((Drink) -> Void)) {
        // 드링크가 선택되어 있을 수도 있고 안되어있을 수도 있음
        // 선택되어 있다면, selectedDrink 값에 넣어줘야 함.
        if let id = drinkId {
            selectedDrinkId = id
        }
        selectedDrinkHandler = selectEventHandler
    }
    
    var initialRow: Int { // 선택된 값 없으면 그냥 첫번째 음료 보여주는 것이 나을 것 같음.
        let rowIndex = drinkList.firstIndex { drink in
            drink.drinkId == selectedDrinkId
        }
        return rowIndex!
    }
    
    var numberOfRows: Int {
        return drinkList.count
    }
    
    func getTitleForRow(_ row: Int) -> String? {
        let selectedDrink = drinkList[row]
        let text = Common.getDrinkText(selectedDrink)
        return text
    }

    func handleCancelButtonTapped(currentVC: UIViewController) {
        currentVC.dismiss(animated: true)
    }

    func handleDoneButtonTapped(currentVC: UIViewController) {
        let drink = drinkList.filter { $0.drinkId == selectedDrinkId }[0]
        selectedDrinkHandler(drink)
        currentVC.dismiss(animated: true)
    }
    
    func handleRowSelection(_ row: Int) {
        selectedDrinkId = drinkList[row].drinkId
    }
}
