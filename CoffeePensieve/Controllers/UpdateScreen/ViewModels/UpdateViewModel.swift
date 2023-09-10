//
//  UpdateViewModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/04.
//

import UIKit

protocol CommitUpdateDelegate: AnyObject {
    func updateCommit(newData: CommitDetail?)
}

class UpdateViewModel {
    
    // TODO: - 의존성 주입
    let commitManager: CommitNetworkManager
    var commitDetail: CommitDetail?
    private var isCreatedMode: Bool = false
    weak var delegate: CommitUpdateDelegate?
    
    var createdAt: Date?
    var drinkId: Int?
    var moodId: Int?
    var tagIds: [Int] = []
    var memo = "" {
        didSet {
            if memo != oldValue {
                onMemoCompleted(memo)
            }
        }
    }
    var drinkDetail: [UpdateCell] = [UpdateCell(title: "When", data: ""),
                                     UpdateCell(title: "Coffee", data: ""),
                                     UpdateCell(title: "Feeling", data: ""),
                                     UpdateCell(title: "Tags", data: "")] {
        didSet {
            onDrinkCompleted(drinkDetail)
            submitAvailable = isSubmitPossible(drinkDetail)
        }
    }
    
    var submitAvailable = false {
        didSet {
            if submitAvailable != oldValue {
                onSubmitCompleted(submitAvailable)
            }
        }
    }
    
    func isSubmitPossible(_ cellList: [UpdateCell]) -> Bool {
        var count = 0
        cellList.forEach { cell in
            if cell.data == "" {
                count += 1
            }
        }
        return count == 0
    }

 
    init(commitManager: CommitNetworkManager, commitDetail: CommitDetail? = nil) {
        self.commitManager = commitManager
        self.commitDetail = commitDetail
        
        // commitDetail이 있으면 기존의 데이터를 수정하는 것
        self.isCreatedMode = commitDetail == nil
        if commitDetail != nil {
            updateSectionListWithData()
            // 데이터가 다 있는 상황이면 저장 가능
            submitAvailable = true
        }
    }
    
    func updateSectionListWithData() {
        let initData = commitDetail!
        let drinkDetail  = [UpdateCell(title: "When", data: getCreatedAtString(initData.createdAt)),
                       UpdateCell(title: "Coffee", data: Common.getDrinkText(initData.drink)),
                       UpdateCell(title: "Feeling", data: Common.getMoodText(initData.mood)),
                       UpdateCell(title: "Tags", data: Common.getTagText(initData.tagList))]
    
        self.createdAt = initData.createdAt
        self.drinkId = initData.drink.drinkId
        self.moodId = initData.mood.moodId
        self.tagIds = initData.tagList.map({ tag in
            return tag.tagId
        })
        self.memo = initData.memo
        self.drinkDetail = drinkDetail
    }
    
    var onDrinkCompleted: ([UpdateCell]) -> Void = { _ in }
    var onSubmitCompleted: (Bool) -> Void = { _ in }
    var onMemoCompleted: (String) -> Void = { _ in }
    
    var naviagtionTitle: String {
        return isCreatedMode ? "Add memory" : "Edit memory"
    }

    func getCreatedAtString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "En")
        dateFormatter.dateFormat = "EE, d MMM 'at' h:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    
    func handleSelectedRow(rowIndex: Int, currentVC: UIViewController) {
        switch rowIndex {
        case 0:
            let dateModalVC = DateModalViewController(time: createdAt)
            Common.resizeModalController(modalVC: dateModalVC)
            dateModalVC.delegate = self
            currentVC.present(dateModalVC, animated: true)
        case 1:
            let drinkModalVC = DrinkModalViewController(drinkId: drinkId)
            Common.resizeModalController(modalVC: drinkModalVC)
            drinkModalVC.delegate = self
            currentVC.present(drinkModalVC, animated: true)
        case 2:
            let moodModalVC = MoodSelectViewController(moodId: moodId)
            moodModalVC.delegate = self
            currentVC.navigationController?.pushViewController(moodModalVC, animated: true)
        case 3:
            let tagVM = TagViewModel()
            tagVM.selectedTagIdList = tagIds
            let tagVC = TagViewController(viewModel: tagVM)
            tagVC.delegate = self
            currentVC.navigationController?.pushViewController(tagVC, animated: true)
        default:
            return
        }
    }
    
    // note 뷰로 넘어가도록 해야 함
    func handleSelectedNote(currentVC: UIViewController) {
        let memoVC = MemoViewController()
        memoVC.memo = memo
        memoVC.delegate = self
        currentVC.navigationController?.pushViewController(memoVC, animated: true)
    }
    
    func handleDoneButtonTapped(currentVC: UIViewController) {
        
        if isCreatedMode {
            createNewCommit(currentVC: currentVC)
        } else {
            Task {
                await updateNewCommit(currentVC: currentVC)
            }
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NewCommitMade"), object: true)
    }
    
    func createNewCommit(currentVC: UIViewController) {
        commitManager.uploadNewDrink(createdAt: createdAt!, drinkId: drinkId!,moodId: moodId!, tagIds: tagIds, memo: memo) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.moveToResultVC(currentVC: currentVC)
                }
            case .failure:
                AlertManager.showTextAlert(on: currentVC, title: "Sorry", message: "Failed to create your memory.") {
                    currentVC.dismiss(animated: true)
                }
            }
        }
    }
    func updateNewCommit(currentVC: UIViewController) async {
        do {
            try await updateCommit()
            DispatchQueue.main.async {
                currentVC.dismiss(animated: true)
            }
        } catch {
            DispatchQueue.main.async {
                AlertManager.showTextAlert(on: currentVC, title: "Sorry", message: "Failed to update your memory.") {
                    currentVC.dismiss(animated: true)
                }
            }
        }
    }
    
    func moveToResultVC(currentVC: UIViewController) {
        let resultVC = CommitResultViewController()
        resultVC.isTrackerMode = true
        resultVC.data = CommitResultDetail(drinkId: drinkId!, moodId: moodId!, tagIds: tagIds, memo: memo, createdAt: createdAt!)
        currentVC.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func updateCommit() async throws {
        guard let pastDetail = commitDetail else { return }
        try await commitManager.updateDrink(documentId: pastDetail.id, createdAt: createdAt!, drinkId: drinkId!, moodId: moodId!, tagIds: tagIds, memo: memo)
        let drink = Constant.drinkList.filter { $0.drinkId == drinkId! }[0]
        let mood = Constant.moodList.filter { $0.moodId == moodId!}[0]
        let tags = tagIds.map { tagId in
            return Constant.tagList.filter { $0.tagId == tagId}[0]
        }
        let newCommit = CommitDetail(id: pastDetail.id, uid: pastDetail.uid, drink: drink, mood: mood, tagList: tags, memo: memo, createdAt: createdAt!)
        self.delegate?.updateCommit(newData: newCommit)
    }
}


extension UpdateViewModel: DateControlDelegate {
    func timeSelected(time: Date) {
        createdAt = time
        drinkDetail[0].data = getCreatedAtString(time)
    }
}

extension UpdateViewModel: DrinkControlDelegate {
    func drinkSelected(drink: Drink) {
        drinkId = drink.drinkId
        drinkDetail[1].data = Common.getDrinkText(drink)
    }
}
extension UpdateViewModel: MoodControlDelegate {
    func moodSelected(mood: Mood) {
        moodId = mood.moodId
        drinkDetail[2].data = Common.getMoodText(mood)
    }
}

extension UpdateViewModel: TagControlDelegate {
    func tagSelected(tagIds: [Int]) {
        var selectedTags: [Tag] = []
        tagIds.forEach { tag in
            let tag = Constant.tagList.filter { $0.tagId == tag }[0]
            selectedTags.append(tag)
        }
        self.tagIds = tagIds
        let tagText = Common.getTagText(selectedTags)
        drinkDetail[3].data = tagText
    }
}

extension UpdateViewModel: MemoControlDelegate {
    func memoEdited(memo: String) {
        if memo == "Add your notes..." {
            return
        }
        let trimmed = memo.trimmingCharacters(in: .whitespacesAndNewlines)
        self.memo = trimmed
    }
}
