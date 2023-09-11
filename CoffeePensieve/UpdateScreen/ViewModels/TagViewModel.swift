//
//  TagViewModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/06.
//

import UIKit

final class TagViewModel {
    
    var selectedTagIdList: [Int] = []
 
    // 태그가 선택되었을 때, 그것을 처리할 함수
    let selectedTagHandler: (([Int]) -> Void)
    
    // 그 함수에 대한 초기화 - viewModel에서 진행
    init(tagSelectionHandler: @escaping (([Int])-> Void)) {
        self.selectedTagHandler = tagSelectionHandler
    }
    
    let rowList = Constant.tagList.map { tag in
        return tag.name
    }
    
    var onRowCompleted: (Int) -> Void = { _ in }
    
    var numberOfRowsInSection: Int {
        return rowList.count
    }
    
    func handleSelectedRow(index: Int, currentVC: UIViewController) {
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
    
    func getCellLabelText(index: Int) -> String {
        return rowList[index]
    }
    
    func getCellCheckStatus(index: Int) -> Bool {
        return selectedTagIdList.contains(index)
    }
    
    // 선택되었을 때 처리할 함수
    func handleDoneButtonTapped() {
        selectedTagHandler(selectedTagIdList)
    }
}
