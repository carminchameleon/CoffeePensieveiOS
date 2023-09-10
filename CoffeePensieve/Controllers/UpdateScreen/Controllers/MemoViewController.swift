//
//  MemoViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/07.
//

import UIKit

protocol MemoControlDelegate: AnyObject {
    func memoEdited(memo: String)
}
class MemoViewController: UIViewController {
    
    var textViewHeightConstant: NSLayoutConstraint!
    var keyboardHeight: CGFloat = 0.0
    weak var delegate: MemoControlDelegate?
    
    var memo: String = "" {
        didSet {
            if !memo.isEmpty {
                textField.textColor = .black
                textField.text = memo
            }
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        return stackView
    }()
    
    let textField : UITextView = {
        let textField = UITextView()
        textField.backgroundColor = .white
        textField.textColor = .lightGray
        textField.text = "Add your notes..."
        textField.isScrollEnabled = true
        textField.layer.cornerRadius = 12
        textField.font =  UIFont.italicSystemFont(ofSize: 17)
        textField.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.spellCheckingType = UITextSpellCheckingType.no
        return textField
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigation()
        textField.delegate = self
    }

    func setNavigation() {
        navigationItem.title = "Memos"
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func doneButtonTapped() {
        delegate?.memoEdited(memo: textField.text)
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    func setUI() {
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        textViewHeightConstant = textField.heightAnchor.constraint(equalToConstant: 400)
        stackView.addArrangedSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0),
            textField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            textField.heightAnchor.constraint(equalToConstant: 480)
        ])
    }
}


extension MemoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textField.textColor == UIColor.lightGray {
            textField.text = ""
            textField.textColor = .black
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textField.text.isEmpty {
            textField.text = "Add your notes..."
            textField.textColor = UIColor.lightGray
        }
    }
}
