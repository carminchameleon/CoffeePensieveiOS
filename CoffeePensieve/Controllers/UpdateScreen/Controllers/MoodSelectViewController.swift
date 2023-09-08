//
//  MoodSelectViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/08.
//

import UIKit
//protocol MoodControlDelegate {
//    func moodSelected(mood: Mood)
//}

class MoodSelectViewController: UIViewController {
    
    var moodList = Constant.moodList
    var selectedMood: Int? = 0
    var delegate: MoodControlDelegate?
    
    let relativeFontConstant: CGFloat = 0.048
    let relativeFontConstant2: CGFloat = 0.016
    
    let cancelButton = ModalTextButton(title: "Cancel")
    let doneButton = ModalTextButton(title: "Done")
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return cv
    }()

    init(moodId: Int?) {
        super.init(nibName: nil, bundle: nil)
        if let id = moodId {
            self.selectedMood = id
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configureCollection()
        setNavigationBar()
    }
    
    func setNavigationBar() {
        navigationItem.title = "Feeling"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }

    
    func configureCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MoodSelectCollectionViewCell.self, forCellWithReuseIdentifier: CellId.moodCell.rawValue)
    }

    
    @objc func doneButtonTapped() {
        let mood = moodList.filter { $0.moodId == selectedMood }[0]
        delegate?.moodSelected(mood: mood)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setUI() {
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}
extension MoodSelectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moodList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.moodCell.rawValue, for: indexPath) as! MoodSelectCollectionViewCell
        let data = Constant.moodList[indexPath.row]
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 18
        cell.iconImage.image = data.image.image(pointSize: 100)
        cell.moodLabel.text = data.name
        cell.moodLabel.font = cell.moodLabel.font.withSize(self.view.frame.height * relativeFontConstant2)
        if selectedMood != nil, selectedMood! == indexPath.row {
            cell.backgroundColor = .primaryColor100
            cell.moodLabel.textColor = .primaryColor500
            cell.layer.borderWidth = 2
            cell.layer.borderColor = #colorLiteral(red: 0.1058823529, green: 0.3019607843, blue: 1, alpha: 1)
        } else {
            cell.layer.borderWidth = 0
            cell.backgroundColor = .white
            cell.moodLabel.textColor = .black
        }
        return cell
    }
}



extension MoodSelectViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (collectionView.frame.width - 24) / 3, height: (collectionView.frame.width - 24) / 3)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMood = indexPath.row
        collectionView.reloadData()
    }
    
}
