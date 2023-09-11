//
//  DateTableViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/06.
//

import UIKit

class DateTableViewCell: UITableViewCell {
    
    var cellData: UpdateCell? = nil {
        didSet {
            if let cellData = cellData {
                titleLabel.text = cellData.title
                timePicker.date = cellData.data
            }
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.headline
        label.text = "Title"
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    let timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "en_US")
        return datePicker
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print(selected)
        // Configure the view for the selected state
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

        
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dataLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dataLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12),
            dataLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            dataLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    
    
    
}
