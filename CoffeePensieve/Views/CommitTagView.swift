//
//  CommitTagView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/05.
//

import UIKit

class CommitTagView: UIView {

    var memoViewTopConstraint: NSLayoutConstraint!
    var memoViewHeightConstraint: NSLayoutConstraint!
    var memoViewBottomConstraint: NSLayoutConstraint!
    
    let progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .bar)
        bar.setProgress(1, animated: false)
        bar.trackTintColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
        bar.tintColor = .primaryColor500
        bar.layer.masksToBounds = true
        bar.layer.cornerRadius = 6
        return bar
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Check your coffee tags"
        label.font = FontStyle.headline
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    
    var selectedTag: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = FontStyle.callOut
        label.textColor = .primaryColor700
        label.textAlignment = .center
        return label
    }()
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return cv
    }()
    
    let memoView: UITextView = {
        
        let textView = UITextView()
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.textAlignment = NSTextAlignment.left
        
        textView.backgroundColor = .primaryColor25
        textView.font =  UIFont.italicSystemFont(ofSize: 17)
        textView.isSelectable = true
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        textView.layer.cornerRadius = 12
        textView.text = "add a note..."
        textView.textColor = .lightGray
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.spellCheckingType = UITextSpellCheckingType.no
        textView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.isEditable = true
         
        return textView
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        setNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }


    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            collectionView.isHidden = true
            memoViewTopConstraint.constant = -240
            memoViewBottomConstraint.constant = -(keyboardSize.height + 20)
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
            collectionView.isHidden = false
            memoViewTopConstraint.constant = 0
            memoViewBottomConstraint.constant = -20

            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
            
            self.addSubview(selectedTag)
            selectedTag.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                selectedTag.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
                selectedTag.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
                selectedTag.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
                selectedTag.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        
            self.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: selectedTag.bottomAnchor, constant: 32),
                collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
                collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
                collectionView.heightAnchor.constraint(equalToConstant: 240)
            ])
        
            self.addSubview(memoView)
            memoView.translatesAutoresizingMaskIntoConstraints = false
                  
            memoViewTopConstraint = memoView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0)
            memoViewHeightConstraint = memoView.heightAnchor.constraint(equalToConstant: 180)
            memoViewBottomConstraint =  memoView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)

            NSLayoutConstraint.activate([
            memoViewTopConstraint,
            memoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            memoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            memoViewBottomConstraint,
        ])
        

    }
    
    
    
}
