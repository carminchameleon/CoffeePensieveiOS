//
//  MoodViewModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/11.
//

import UIKit

final class MoodViewModel {
    
    var moodList = Constant.moodList
    var selectedMood: Int?
    let selectedMoodHandler: ((Mood) -> Void)

    init(moodSelectionHandler: @escaping ((Mood) -> Void)) {
        self.selectedMoodHandler = moodSelectionHandler
    }
    
    var numberOfItemsInSection: Int {
        return moodList.count
    }

    func getCellData(index: Int) -> Mood {
        return Constant.moodList[index]
    }
  
    func isSelectedMoodCell(index: Int) -> Bool {
        return selectedMood != nil && selectedMood! == index
    }
  
    func handleMoodSelected(index: Int) {
        selectedMood = index
        let mood = moodList.filter { $0.moodId == selectedMood }[0]
        selectedMoodHandler(mood)
    }
}
