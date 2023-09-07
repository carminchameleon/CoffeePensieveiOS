//
//  CommitResultViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/07.
//

import UIKit

final class CommitResultViewController: UIViewController {
    
    let resultView = CommitResultView()
    
    var data: CommitResultDetail?
    
    override func loadView() {
        view = resultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
   
    override func viewWillLayoutSubviews() {
        resultView.setGradient3Color(color1: .blueGradient100, color2: .blueGradient200, color3: .blueGradient300)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .primaryColor500
    }
    
    override func viewDidLayoutSubviews() {
        updateMemoData()
    }
        
    func setUI() {
        resultView.backgroundColor = .white
        navigationItem.title = "Memory"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeTapped))
        updateUIWithData()
    }
    
    @objc func closeTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

    func updateUIWithData() {
        resultView.createdAtLabel.text = data?.createdAtString
        resultView.drinkLabel.text = data?.drinkLabelString
        resultView.coffeeImage.image = data?.drinkImage
        resultView.moodLabel.text = data?.moodNameString
        resultView.moodImage.text = data?.moodImageString
        resultView.tags.text = data?.tagString
    }

    func updateMemoData() {
        guard let memo = data?.memo else { return }
        if memo.isEmpty {
            resultView.detailTitle.isHidden = true
            return
        }
        // get memo text height
        let width = resultView.frame.width - 48
        let font =  UIFont.italicSystemFont(ofSize: 17)
        let memoTextHeight =  Common.heightForView(text: memo, font: font, width: width)
        let emptySpaceHeight = resultView.frame.height - resultView.detailTitle.frame.maxY - 24
        
        if memoTextHeight > emptySpaceHeight {
            setMemoView(memo)
        } else {
            setDetailView(memo)
        }
    }

    func setMemoView(_ memo: String) {
        resultView.addSubview(resultView.memoView)
        resultView.memoView.translatesAutoresizingMaskIntoConstraints = false
        resultView.memoView.text = memo
        
        NSLayoutConstraint.activate([
            resultView.memoView.topAnchor.constraint(equalTo: resultView.detailTitle.bottomAnchor, constant: 12),
            resultView.memoView.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 24),
            resultView.memoView.trailingAnchor.constraint(equalTo: resultView.trailingAnchor, constant: -24),
            resultView.memoView.bottomAnchor.constraint(equalTo: resultView.safeAreaLayoutGuide.bottomAnchor, constant: -12),
        ])
    }
    
    func setDetailView(_ memo: String) {
        resultView.addSubview(resultView.detailView)
        resultView.detailView.translatesAutoresizingMaskIntoConstraints = false
        resultView.detailView.text = memo
        
        NSLayoutConstraint.activate([
            resultView.detailView.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 24),
            resultView.detailView.trailingAnchor.constraint(equalTo: resultView.trailingAnchor, constant: -24),
            resultView.detailView.topAnchor.constraint(equalTo: resultView.detailTitle.bottomAnchor, constant: 12)

        ])
    }
}
