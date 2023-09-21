//
//  BindingTextField.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/12.
//

import UIKit

class BindingTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 글자가 변할때마다 호출될 메서드
    @objc func textFieldDidChanged(_ textField: UITextField) {
        if let text = textField.text {
            observerCallback(text)
        }
    }

    private func commonAddTarget(){
        self.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    }

    // 호출할 함수
    private var observerCallback: (String) -> Void = { _ in }

    func binding(callback: @escaping (String) -> Void) {
        observerCallback = callback
    }
    
}
