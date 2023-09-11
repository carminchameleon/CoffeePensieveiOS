//
//  MoodSelectViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/08.
//

import UIKit

final class MoodSelectViewController: UIViewController {
    
    var viewModel: MoodViewModel
    let relativeFontConstant: CGFloat = 0.016
    
    let cancelButton = ModalTextButton(title: "Cancel")
    let doneButton = ModalTextButton(title: "Done")
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return cv
    }()

    init(viewModel: MoodViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        setupAutolayout()
        configureCollectionView()
        setNavigationBar()
    }
    
    func setNavigationBar() {
        navigationItem.title = "Feeling"
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MoodSelectCollectionViewCell.self, forCellWithReuseIdentifier: CellId.moodCell.rawValue)
    }
}

extension MoodSelectViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.moodCell.rawValue,
                                                      for: indexPath) as! MoodSelectCollectionViewCell
        cell.data = viewModel.getCellData(index: indexPath.row)
        cell.isSelectedCell = viewModel.isSelectedMoodCell(index: indexPath.row)
        let viewHeight = view.frame.height
        cell.moodLabel.font = cell.moodLabel.font.withSize(viewHeight * relativeFontConstant)
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
        viewModel.handleMoodSelected(index: indexPath.row)
        collectionView.reloadData()
    }
}

extension MoodSelectViewController: AutoLayoutable {
    func setBackgroundColor() {
        view.backgroundColor = .systemGroupedBackground
        collectionView.backgroundColor = .systemGroupedBackground
    }
    
    func setupAutolayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
