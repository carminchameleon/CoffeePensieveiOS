//
//  TrackerLoadingTableViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/15.
//

import UIKit

class TrackerLoadingTableViewCell: UITableViewCell {
    
    var title: String?  {
        didSet {
            guard let title = title else { return }
            titleLabel.text = title
        }
    }
    
    lazy var stackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [titleLabel])
        return st
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Data is loading 😌"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
        return label
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.addSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
    
    func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([

            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
        ])
    }

}
