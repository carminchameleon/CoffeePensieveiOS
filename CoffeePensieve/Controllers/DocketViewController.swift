//
//  DocketViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/17.
//

import UIKit

class DocketViewController: UIViewController {
    
    let docketView = DocketView()
    let dataManager = DataManager.shared
    
    override func loadView() {
        view = docketView
    }

    // ViewController 오픈할 때
    // Commit 데이터 자체를 넣어줄 것임
    
    var commit: CommitDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        updateCommitData()
        updateDetail()
    }

    override func viewWillLayoutSubviews() {
        docketView.setGradient3Color(color1: .blueGradient100, color2: .blueGradient200, color3: .blueGradient300)
    }
        
    func setNavigationBar() {        
        navigationItem.title = "Memory"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
        tabBarController?.tabBar.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped))
    }

    func updateCommitData() {

        guard let commit = commit else { return }

        // drink
        let tempMode = commit.drink.isIced ? "🧊ICED" : "🔥HOT"
        docketView.coffeeImage.image = UIImage(named: commit.drink.image)
        docketView.drinkLabel.text = "\(tempMode) / \(commit.drink.name.uppercased())"
        // mood
        docketView.moodLabel.text = commit.mood.name.uppercased()
        docketView.moodImage.text = commit.mood.image
        // tags
        docketView.tags.text = commit.tagList.reduce("", { $0 + " " + "#\($1.name.uppercased())" })
        docketView.createdAtLabel.text = getCreatedAtString(commit.createdAt)
    }
    
    func getCreatedAtString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "En")
        dateFormatter.dateFormat = "EEEE, MMMM d 'at' h:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func updateDetail() {
        guard let memo = commit?.memo else { return }
        let width = docketView.frame.width - 48
        
        if memo.isEmpty {
            docketView.detailTitle.isHidden = true
            return
        }

        let font =  UIFont.italicSystemFont(ofSize: 17)
        let height =  Common.heightForView(text: memo, font: font, width: width)
        if height > 500 {
            docketView.addSubview(docketView.memoView)
            docketView.memoView.translatesAutoresizingMaskIntoConstraints = false
            docketView.memoView.text = memo
            NSLayoutConstraint.activate([
                docketView.memoView.topAnchor.constraint(equalTo: docketView.detailTitle.bottomAnchor, constant: 12),
                docketView.memoView.leadingAnchor.constraint(equalTo: docketView.leadingAnchor, constant: 24),
                docketView.memoView.trailingAnchor.constraint(equalTo: docketView.trailingAnchor, constant: -24),
                docketView.memoView.bottomAnchor.constraint(equalTo: docketView.safeAreaLayoutGuide.bottomAnchor, constant: -12),
        ])
        } else {
            docketView.detailView.text = memo
            docketView.addSubview(docketView.detailView)
            docketView.detailView.topAnchor.constraint(equalTo: docketView.detailTitle.bottomAnchor, constant: 12).isActive = true

        }
    }
    
    init(commit: CommitDetail?) {
        super.init(nibName: nil, bundle: nil)
        self.commit = commit
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteButtonTapped() {
        
    }
}
