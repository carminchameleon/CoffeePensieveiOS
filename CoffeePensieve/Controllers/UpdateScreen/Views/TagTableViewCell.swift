//
//  TagTableViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/06.
//

import UIKit

final class TagTableViewCell: UITableViewCell {

    let dataLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.callOut
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        self.addSubview(dataLabel)
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dataLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dataLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            dataLabel.heightAnchor.constraint(equalToConstant: 30),
        ])

    }
}
