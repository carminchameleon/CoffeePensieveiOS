//
//  CalendarCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/19.
//

import UIKit

class CalendarCell: UIView {
    
    let cell: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .primaryColor500
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeUI() {
        addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cell.topAnchor.constraint(equalTo: self.topAnchor),
            cell.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cell.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cell.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
