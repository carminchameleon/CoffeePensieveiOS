//
//  CommitMainView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/01.
//

import UIKit

class CommitMainView: UIView {
    
    
    let morningGreeting = [
    "I hope you had a good night’s sleep",
    "I hope you woke up feeling refreshed",
    "I hope you had sweet dreams",
    "The world is waiting for you.",
    "sleepyhead! Let's conquer the day together.",
    "Sending positive vibes your way.",
    "May your morning be as wonderful as you are.",
    "Here's to a new day full of endless possibilities.",
    ]
    
    let afternoonGreeting = [
    "I hope you end your day on a high note",
    "How has your day been so far?",
    "Wishing you a great afternoon ahead.",
    "May your day be filled with\n productivity and success.",
    "May your day be filled with\n joy and productivity.",
    "how's your day going?\n Hope it's been great so far.",
    "Keep up the good workn you're doing great!",
    "May your morning be as wonderful as you are.",
    "May the rest of your day be \nas awesome as you are.",
    "Wishing you a peaceful and \nstress-free afternoon.",
    "Remember to take a break and \nenjoy the little things in life."
    ]
    
    let eveningGreeting = [
        "I hope your evening is filled\n with laughter and joy",
        "I hope you have a restful and rejuvenating night",
        "I hope you have a delicious dinner \nand a wonderful evening",
        "Sleep well and sweet dreams",
        "I hope you wake up feeling refreshed\n and ready for a new day",
        "I wish you a peaceful and restful night",
        "Wishing you a relaxing and enjoyable evening.",
        "May your night be filled \nwith peace and tranquility.",
        "Hope you had a good day and\n are looking forward to a great evening.",
        "Take a deep breath and let go\n of any stress from the day.",
        "May your evening be filled with\n laughter and good company.",
        "Remember to take some time for yourself\n and do something you enjoy.",
        "Wishing you a night full of \nsweet dreams and happy thoughts.",
        "Hope you have a chance to unwind \nand recharge before the day is over.",
        "May your evening be as wonderful as you are."
    ]
    
    
    let greetingLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.title2
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var cheeringLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .grayColor500
        label.numberOfLines = 0
        label.textAlignment = .center
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let date = dateFormatter.string(from: nowDate)// 현재 시간의 Date를 format에 맞춰 string으로 반환
        let currentTime = Int(date)!
        switch currentTime {
        case 0...12 :
            label.text = morningGreeting.randomElement()
        case 12...17 :
            label.text = afternoonGreeting.randomElement()
        default:
            label.text = eveningGreeting.randomElement()
        }
        return label
    }()

    let suggestionLabel: UILabel = {
        let label = UILabel()
//        label.text = "Would you like to add your coffee memory?"
        label.font = FontStyle.callOut
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var imageView: UIImageView = {
        let imageName = "Memory-0"
        let onboardingImage = UIImage(named: imageName)
        let imageView = UIImageView(image: onboardingImage!)
        imageView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        imageView.contentMode =  .scaleToFill
        return imageView
    }()
    
    // MARK: - 다음 동작 버튼
    let addButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Add Coffee Memory", for: .normal)
        button.titleLabel?.font = FontStyle.body
        button.setTitleColor(UIColor.primaryColor500, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
    
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setUI() {

        self.addSubview(greetingLabel)

        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            greetingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            greetingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])

        self.addSubview(cheeringLabel)
        cheeringLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cheeringLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 16),
            cheeringLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            cheeringLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
        
     
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
         
            imageView.topAnchor.constraint(equalTo: cheeringLabel.bottomAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
        ])

        self.addSubview(suggestionLabel)
        suggestionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            suggestionLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -130),
            suggestionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            suggestionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])

        
        
        self.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -88),
            addButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 36),
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -36),
            addButton.heightAnchor.constraint(equalToConstant: ContentHeight.buttonHeight)
        ])
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
     let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
     label.numberOfLines = 0
     label.lineBreakMode = NSLineBreakMode.byWordWrapping
     label.font = font
     label.text = text

     label.sizeToFit()
     return label.frame.height
    }

}

