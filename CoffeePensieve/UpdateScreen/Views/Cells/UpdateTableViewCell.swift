//
//  UpdateTableViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/05.
//

import UIKit

class UpdateTableViewCell: UITableViewCell {
    
    var cellTrailingMarginConstraint: NSLayoutConstraint!

    var cellData: UpdateCell? = nil {
        didSet {
            if let cellData = cellData {
                titleLabel.text = cellData.title
                dataLabel.text = cellData.data
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.subhead
        label.text = "Title"
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    let dataLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.callOut
        label.text = "data"
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        self.addSubview(titleLabel)
        self.addSubview(dataLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.widthAnchor.constraint(equalToConstant: 60),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        cellTrailingMarginConstraint = dataLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dataLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dataLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12),
            cellTrailingMarginConstraint,
            dataLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
