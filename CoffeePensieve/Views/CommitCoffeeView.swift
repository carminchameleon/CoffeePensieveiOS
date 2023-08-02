//
//  CommitCoffeeView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/02.
//

import UIKit

class CommitCoffeeView: UIView {
    
    let progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .bar)
        bar.setProgress(0.3, animated: false)
        bar.trackTintColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
        bar.tintColor = .primaryColor500
        bar.layer.masksToBounds = true
        bar.layer.cornerRadius = 6
        return bar
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "What kind of coffee did you drink?"
        label.font = FontStyle.headline
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let selectedDrink: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = FontStyle.callOut
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let tempController: UISegmentedControl = {
        let items = ["HOT","ICED"]
        let controller = UISegmentedControl(items: items)
        let frame = UIScreen.main.bounds
        controller.frame = CGRectMake(frame.minX + 10, frame.minY + 50,
                                         frame.width - 20, frame.height*0.1)
        controller.layer.cornerRadius = 5.0
        controller.backgroundColor = .primaryColor400
        controller.tintColor = .white
        controller.selectedSegmentIndex = 0
        return controller
    }()
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return cv
        
    }()
    
    let continueButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = FontStyle.body
        button.setTitleColor(UIColor.primaryColor300, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {

        self.addSubview(progressBar)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(questionLabel)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(selectedDrink)
        selectedDrink.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(tempController)
        tempController.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            progressBar.heightAnchor.constraint(equalToConstant: 10)
        ])
    
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 24),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            questionLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            selectedDrink.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            selectedDrink.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            selectedDrink.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            selectedDrink.heightAnchor.constraint(equalToConstant: 20)
        ])

        
        NSLayoutConstraint.activate([
            tempController.topAnchor.constraint(equalTo: selectedDrink.bottomAnchor, constant: 24),
            tempController.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            tempController.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            tempController.heightAnchor.constraint(equalToConstant: 30)
        ])
    
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: tempController.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1)
        ])
        
        self.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -76),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            continueButton.heightAnchor.constraint(equalToConstant: ContentHeight.buttonHeight)
        ])
        
    }

}
