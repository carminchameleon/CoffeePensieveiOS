//
//  CommitMoodView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/05.
//

import UIKit

class CommitMoodView: UIView {
    
    let progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .bar)
        bar.setProgress(0.65, animated: false)
        bar.trackTintColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
        bar.tintColor = .primaryColor500
        bar.layer.masksToBounds = true
        bar.layer.cornerRadius = 6
        return bar
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "How are you feeling now?"
        label.font = FontStyle.headline
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    var selectedMood: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = FontStyle.callOut
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return cv
        
    }()

    let continueButton = CustomButton(isEnabled: false, title: "Continue")
    
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
        
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            progressBar.heightAnchor.constraint(equalToConstant: 10)
        ])
    
 
        self.addSubview(questionLabel)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 24),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            questionLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        self.addSubview(selectedMood)
        selectedMood.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectedMood.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            selectedMood.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            selectedMood.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            selectedMood.heightAnchor.constraint(equalToConstant: 20)
        ])

        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: selectedMood.bottomAnchor, constant: 32),
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
