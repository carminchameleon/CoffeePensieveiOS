//
//  TagViewModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/06.
//

import UIKit

// view를 만드는데 필요한 데이터 - tableView 뿌릴 list
// 선택된 데이터를 표시
// 선택된 cell에 대한 응답

class TagViewModel {
    
    var selectedTagIdList: [Int] = []

    let rowList = Constant.tagList.map { tag in
        return tag.name
    }
    
    var onRowCompleted: (Int) -> Void = { _ in}

    
    var numberOfRowsInSection: Int {
        return rowList.count
    }
    
    func handleSelectedRow(index: Int, currentVC: UIViewController) {
        // deselect
        if let index =  selectedTagIdList.firstIndex(of: index) {
            selectedTagIdList.remove(at: index)
        } else {
            if selectedTagIdList.count == 2 {
                AlertManager.showTextAlert(on: currentVC, title: "Tags limit", message: "You can select up to two.")
                return
            }
            selectedTagIdList.append(index)
        }
        onRowCompleted(index)
    }
    
    // MARK: - cell 관련 데이터 표시
    func getCellLabelText(index: Int) -> String {
        return rowList[index]
    }
    
    func getCellCheckStatus(index: Int) -> Bool {
        return selectedTagIdList.contains(index)
    }
    
}
