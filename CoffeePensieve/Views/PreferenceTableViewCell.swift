//
//  PreferenceTableViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/26.
//

import UIKit

class PreferenceTableViewCell: UITableViewCell {
    
    var model: PreferenceCell? = nil {
        didSet {
            guard let model = model else { return }
            iconView.image = UIImage(systemName: model.icon)
            menuLabel.text = model.title
            nameTextField.text = model.data
        }
    }
    
    // 클로저 패턴으로 데이터 전달
    var handleNameField: (UITextField) -> Void = {(sender) in }
    
    let iconView: UIImageView = {
        let image = UIImage(systemName: "face.smiling")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .primaryColor500
        return imageView
    }()
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.callOut
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()

    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearButtonMode = .whileEditing
        tf.textAlignment = .left
        tf.attributedPlaceholder = NSAttributedString(string: "A.k.a Dumbledore", attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayColor400])
        return tf
    }()

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.addSubview(menuLabel)
        self.addSubview(iconView)
        self.addSubview(nameTextField)
        
        nameTextField.addTarget(self, action: #selector(nameFieldChanged(_:)), for: .editingChanged)
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func nameFieldChanged(_ sender: UITextField) {
        handleNameField(sender)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder() // 키보드 숨김
            return true
    }
    
    func setConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            iconView.heightAnchor.constraint(equalToConstant: 25),
            iconView.widthAnchor.constraint(equalToConstant: 25),
        ])
        
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            menuLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            menuLabel.heightAnchor.constraint(equalToConstant: 30),
            menuLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)

        ])

        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -200),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            nameTextField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
