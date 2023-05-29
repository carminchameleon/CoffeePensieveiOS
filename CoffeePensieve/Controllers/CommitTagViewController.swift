//
//  CommitTagViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/05.
//

import UIKit

class CommitTagViewController: UIViewController {

    let dataManager = DataManager.shared

    var tags: [Tag] = []
    let tagView = CommitTagView()
    var memo: String? = ""
    
    var selectedDrink: Int?
    var selectedMood: Int?
    var selectedTags: [Int] = [] 

    override func loadView() {
        view = tagView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTagData()
        addTargets()
        setCollection()
    }
    
    func setTagData() {
        let tagList = dataManager.getTagListFromAPI()
        tags = tagList
    }
    func setUI() {
        view.backgroundColor = .white
    }
    
    func addTargets() {
        tagView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchDown)
    }

    
    func setCollection() {
        tagView.collectionView.delegate = self
        tagView.collectionView.dataSource = self
        tagView.memoView.delegate = self
        tagView.collectionView.register(CommitTagCollectionViewCell.self, forCellWithReuseIdentifier: CellId.commitTagCell.rawValue)
    }

    @objc func saveButtonTapped() {
        let loadingVC = CommitLoadingViewController()
        loadingVC.selectedDrink = selectedDrink
        loadingVC.selectedMood = selectedMood
        loadingVC.selectedTags = selectedTags
        loadingVC.memo = tagView.memoView.text == "add a note..." ? "" : tagView.memoView.text
        navigationController?.pushViewController(loadingVC, animated: true)
    }

}

extension CommitTagViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    // 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagView.collectionView.dequeueReusableCell(withReuseIdentifier: CellId.commitTagCell.rawValue, for: indexPath) as! CommitTagCollectionViewCell
        cell.titleLabel.text = tags[indexPath.row].name
        cell.layer.borderWidth = 2
        cell.layer.borderColor = #colorLiteral(red: 0.1058823529, green: 0.3019607843, blue: 1, alpha: 1)
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 12
        
        if selectedTags.firstIndex(of: indexPath.row) != nil {
            cell.backgroundColor = .primaryColor100
            cell.titleLabel.textColor = .primaryColor500
        } else {
            cell.backgroundColor = .white
            cell.titleLabel.textColor = .black
        }
        return cell
    }
}

extension CommitTagViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 10) / 2, height: (collectionView.frame.height - 15) / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = tags[indexPath.row]
        if selectedTags.isEmpty {
            selectedTags.append(indexPath.row)
            tagView.selectedTag.text = "\(tag.name)"
            controlTagView(isActive: true)
        } else if let index = selectedTags.firstIndex(of: indexPath.row) {
            selectedTags.remove(at: index)
            if selectedTags.isEmpty {
                tagView.selectedTag.text = ""
                controlTagView(isActive: false)
            } else {
                tagView.selectedTag.text = tags[selectedTags[0]].name
                controlTagView(isActive: true)
            }
        } else {
            if selectedTags.count > 1 {
                let failAlert = UIAlertController(title: "Tags limit", message: "You can select up to two.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .default)
                failAlert.addAction(okayAction)
                self.present(failAlert, animated: true, completion: nil)
            } else {
                selectedTags.append(indexPath.row)
                let currentTag = tagView.selectedTag.text!
                tagView.selectedTag.text = "\(currentTag) & \(tag.name)"
                controlTagView(isActive: true)
            }
        }
    }
    
    func controlTagView(isActive: Bool) {
        if isActive {
            tagView.saveButton.isEnabled = true
            tagView.saveButton.setTitleColor(UIColor.primaryColor500, for: .normal)
        } else {
            tagView.saveButton.isEnabled = false
            tagView.saveButton.setTitleColor(UIColor.primaryColor300, for: .normal)
        }
        tagView.collectionView.reloadData()
    }
    
}
extension CommitTagViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "add a note..."
            textView.textColor = UIColor.lightGray
        }
    }
}
