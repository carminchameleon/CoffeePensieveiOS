//
//  NoteTableViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/07.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    var noteText: String = "" {
        didSet {
            if noteText.isEmpty {
                noteLabel.text = "add a note..."
                noteLabel.textColor = .grayColor300
            } else {
                noteLabel.text = noteText
                noteLabel.textColor = .black
            }
        }
    }
    // 만약 노트가 없을 경우에
    let noteLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.callOut
        label.textAlignment = .left
        label.numberOfLines = 3
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
        addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            noteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            noteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
        ])
        
    }
}
