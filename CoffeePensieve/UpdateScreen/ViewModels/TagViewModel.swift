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
    
    var numberOfRowsInSection: Int {
        return rowList.count
    }
    
    func handleSelectedRow(index: Int, currentVC: UIViewController) {
        // 이미 선택되어 있는 경우
        if let index =  selectedTagIdList.firstIndex(of: index) {
            // 기존 리스트에서 삭제
            selectedTagIdList.remove(at: index)
        } else {
            // 새롭게 추가된 선택인데, 2개를 넘을 경우: 제한 문구를 띄운다.
            if selectedTagIdList.count == 2 {
                AlertManager.showTextAlert(on: currentVC, title: "Tags limit", message: "You can select up to two.")
                return
            }
            selectedTagIdList.append(index)
        }
        // 1. updateViewModel에 새롭게 업데이트된 tag리스트를 전달한다.
        selectedTagHandler(selectedTagIdList)
    }
    
    func getCellLabelText(index: Int) -> String {
        return rowList[index]
    }
    
    func getCellCheckStatus(index: Int) -> Bool {
        return selectedTagIdList.contains(index)
    }
}
