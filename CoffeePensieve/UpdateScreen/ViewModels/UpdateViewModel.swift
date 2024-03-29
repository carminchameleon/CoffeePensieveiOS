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

final class UpdateViewModel {
    
    let placeholderText = "Add your notes..."
    let commitManager = CommitNetworkManager.shared
    var commitDetail: CommitDetail?
    private var isCreatedMode: Bool = false
    weak var delegate: CommitUpdateDelegate?
    
    var createdAt: Date?
    var drinkId: Int?
    var moodId: Int?
    var tagIds: [Int] = []
    
    var memo = Observable("")
    var submitAvailable = Observable(false)
    var drinkDetail: [UpdateCell] = [UpdateCell(title: "Date", data: ""),
                                     UpdateCell(title: "Coffee", data: ""),
                                     UpdateCell(title: "Feeling", data: ""),
                                     UpdateCell(title: "Tags", data: "")] {
        didSet {
            onDrinkCompleted(drinkDetail)
            submitAvailable.value = isSubmitPossible(drinkDetail)
        }
    }
    var onDrinkCompleted: ([UpdateCell]) -> Void = { _ in }

    init(commitDetail: CommitDetail? = nil) {
        self.commitDetail = commitDetail
        // commitDetail이 있으면 기존의 데이터를 수정하는 것
        self.isCreatedMode = commitDetail == nil
        if commitDetail != nil {
            updateSectionListWithData()
            // 데이터가 다 있는 상황이면 저장 가능
            submitAvailable.value = true
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
        self.tagIds = initData.tagList.map({ $0.tagId })
        self.memo.value = initData.memo
        self.drinkDetail = drinkDetail
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
            let drinkViewModel = DrinkModalViewModel(selectEventHandler: updateDrinkData)
            if let drinkId = drinkId {   drinkViewModel.selectedDrinkId = drinkId }
            let drinkModalVC = DrinkModalViewController(viewModel: drinkViewModel)
            Common.resizeModalController(modalVC: drinkModalVC)
            currentVC.present(drinkModalVC, animated: true)
        case 2:
            let moodViewModel = MoodViewModel()
            moodViewModel.selectedMood = moodId
            moodViewModel.moodSelectionHandler = updateMoodData
            let moodModalVC = MoodSelectViewController(viewModel: moodViewModel)
            currentVC.navigationController?.pushViewController(moodModalVC, animated: true)
        case 3:
            // VC에서 어떤 함수를 실행했고, 그 함수 실행에 대한 결과를 내가 받아와야 할때
            // VC에서 output을 만들면 나도 그 output을 이렇게 반영할거야.
            // 내가 그 output을 이렇게 처리해야해.
            let tagVM = TagViewModel(tagSelectionHandler: tagSelecting)
            // tagView모델이 자신의 어떤 태그가 탭 되었는지를 알 수 있는
            tagVM.selectedTagIdList = tagIds
            let tagVC = TagViewController(viewModel: tagVM)
            currentVC.navigationController?.pushViewController(tagVC, animated: true)
        default:
            return
        }
    }
    
    func tagSelecting(tagIds: [Int]) {
        var selectedTags: [Tag] = []
        tagIds.forEach { tag in
            let tag = Constant.tagList.filter { $0.tagId == tag }[0]
            selectedTags.append(tag)
        }
        self.tagIds = tagIds
        let tagText = Common.getTagText(selectedTags)
        drinkDetail[3].data = tagText
    }
    
    func updateDrinkData(drink: Drink) {
        drinkId = drink.drinkId
        drinkDetail[1].data = Common.getDrinkText(drink)
    }
    
    func updateMoodData(mood: Mood) {
        moodId = mood.moodId
        drinkDetail[2].data = Common.getMoodText(mood)
    }
    // note 뷰로 넘어가도록 해야 함
    func handleSelectedNote(currentVC: UIViewController) {
        let memoVC = MemoViewController()
        memoVC.memo = memo.value
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
    
    func getRowData(index: Int) -> UpdateCell {
        let rowData = drinkDetail[index]
        return rowData
    }
    
    func createNewCommit(currentVC: UIViewController) {
        commitManager.uploadNewDrink(createdAt: createdAt!, drinkId: drinkId!,moodId: moodId!, tagIds: tagIds, memo: memo.value) { result in
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
        resultVC.data = CommitResultDetail(drinkId: drinkId!, moodId: moodId!, tagIds: tagIds, memo: memo.value, createdAt: createdAt!)
        currentVC.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func updateCommit() async throws {
        guard let pastDetail = commitDetail else { return }
        try await commitManager.updateDrink(documentId: pastDetail.id, createdAt: createdAt!, drinkId: drinkId!, moodId: moodId!, tagIds: tagIds, memo: memo.value)
        let drink = Constant.drinkList.filter { $0.drinkId == drinkId! }[0]
        let mood = Constant.moodList.filter { $0.moodId == moodId!}[0]
        let tags = tagIds.map { tagId in
            return Constant.tagList.filter { $0.tagId == tagId}[0]
        }
        let newCommit = CommitDetail(id: pastDetail.id, uid: pastDetail.uid, drink: drink, mood: mood, tagList: tags, memo: memo.value, createdAt: createdAt!)
        self.delegate?.updateCommit(newData: newCommit)
    }
}

extension UpdateViewModel: DateControlDelegate {
    func didSelectTime(time: Date) {
        createdAt = time
        drinkDetail[0].data = getCreatedAtString(time)
    }
}

extension UpdateViewModel: MemoControlDelegate {
    func memoEdited(memo: String) {
        if memo != placeholderText {
            let trimmed = memo.trimmingCharacters(in: .whitespacesAndNewlines)
            self.memo.value = trimmed
        }
    }
}
