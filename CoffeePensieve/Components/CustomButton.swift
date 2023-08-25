//
//  CustomButton.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/08/24.
//

import UIKit

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(isEnabled : Bool = true, title: String) {
        self.init()
        self.isEnabled = isEnabled
        self.setTitle(title, for: .normal)
    }
    
    func setUpButton() {
        titleLabel?.font = FontStyle.body
        clipsToBounds = true
        layer.cornerRadius = 6
    }
        
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = UIColor.primaryColor500
                setTitleColor(UIColor.primaryColor25, for: .normal)

            } else {
                backgroundColor =  UIColor.primaryColor25
                setTitleColor(UIColor.primaryColor300, for: .normal)
            }
        }
    }
    

}
