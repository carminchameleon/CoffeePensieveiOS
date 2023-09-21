//
//  ModalTextButton.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/06.
//

import UIKit

class ModalTextButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init()
        self.setTitle(title, for: .normal)
    }
    
    func setUpButton() {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(.primaryColor500, for: .normal)
    }
}
