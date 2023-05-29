//
//  TrackerRecordTableViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/15.
//

import UIKit

class TrackerRecordTableViewCell: UITableViewCell {
    
    var summary: Summary? {
        didSet {
            guard let summary = summary else { return }
            titleLabel.text = summary.title
            numberLabel.text = String(summary.number)
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()

    let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.addSubview(titleLabel)
        self.addSubview(numberLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
    
    func setConstraints() {
        self.backgroundColor =  #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
        ])
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            numberLabel.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
        ])

    }
    
}
