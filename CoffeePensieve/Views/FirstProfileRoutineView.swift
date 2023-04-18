//
//  FirstProfileRoutineView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/16.
//

import UIKit

class FirstProfileRoutineView: UIView {
    
    private let viewHeight: CGFloat = 40
    private let padding: CGFloat = 12
    
    // MARK: - 메인 레이블 - 정보
    let personalInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Information"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .primaryColor500
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - 서브 레이블
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "NAME"
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textColor = .primaryColor400
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var underline: UIView = {
       let view = UIView()
        view.backgroundColor = .primaryColor400
        return view
    }()
    
    lazy var nameTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 36
        tf.font = UIFont.systemFont(ofSize: 14, weight: .light)
        tf.backgroundColor = .clear
        tf.textColor = .primaryColor400
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.textAlignment = .center
        tf.addSubview(underline)
        
        tf.attributedPlaceholder = NSAttributedString(string: "A.k.a Dumbledore", attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayColor400])

        return tf
    }()
    
    // MARK: - 이름 스택 뷰
    lazy var nameStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        st.spacing = 8
        st.axis = .horizontal
        st.distribution = .fillEqually
        st.alignment = .bottom
        return st
    }()
    
    // MARK: - 개인정보 스택 뷰
    lazy var infoStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [personalInfoLabel, nameStackView])
        st.spacing = 8
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        return st
    }()
    
    
    let limitLabel: UILabel = {
        let label = UILabel()
        label.text = "Caffeine Limit"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .primaryColor500
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    
    let cupLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.text = "CUPS"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .primaryColor400
        return label
    }()
    
    //MARK: - 이메일 입력 필드
    lazy var cupTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 36
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.backgroundColor = .clear
        tf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tf.keyboardType = .numberPad
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.textAlignment = .center
        tf.addSubview(cupUnderline)

        return tf
    }()
    
    lazy var cupUnderline: UIView = {
       let view = UIView()
        view.backgroundColor = .primaryColor400
        return view
    }()
    
    lazy var cupCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "1"
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .primaryColor400
        return label
    }()
    
    
    lazy var cupStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.maximumValue = 10
        stepper.minimumValue = 1
        stepper.stepValue = 1
//        stepper.layer.borderColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
//        stepper.layer.borderWidth = 1
        stepper.autorepeat = true
        return stepper
    }()
    
    lazy var stepStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [cupCountLabel, cupStepper])
        st.spacing = 0
        st.axis = .horizontal
        st.distribution = .fillEqually
        st.alignment = .fill
        return st
    }()
    
    
    lazy var cupStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [cupLabel,stepStackView])
        st.spacing = 8
        st.axis = .horizontal
        st.distribution = .fill
        st.alignment = .fill
        return st
    }()
    
    
    
    let limitTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 1
        label.text = "TIME"
        label.textAlignment = .left
        label.textColor = .primaryColor400
        return label
    }()

    lazy var limitTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .compact
        picker.tintColor = .primaryColor500
        picker.locale = Locale(identifier: "en_US")
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let date = dateFormatter.date(from: "17:00") {
            picker.date = date
        }
        return picker
    }()

    
    lazy var limitTimeStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [limitTimeLabel, limitTimePicker])
        st.spacing = 12
        st.axis = .horizontal
        st.distribution = .fillProportionally
        st.alignment = .fill
        return st
    }()
    
    lazy var limitStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [limitLabel, cupStackView, limitTimeStackView])
        st.spacing = 12
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        return st
    }()
    
    
    // MARK: - 메인 레이블 - 루틴
    let routineLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily routine"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .primaryColor500
        return label
    }()

    // MARK: - 서브 레이블 - 아침
    let morningLabel: UILabel = {
        let label = UILabel()
        label.text = "WAKE UP"
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .primaryColor400
        return label
    }()

    lazy var morningTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .compact
        picker.tintColor = .primaryColor500
        picker.locale = Locale(identifier: "en_US")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let date = dateFormatter.date(from: "7:00") {
            picker.date = date
        }
        
        return picker
    }()

    
    lazy var morningStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [morningLabel, morningTimePicker])
        st.spacing = 12
        st.axis = .horizontal
        st.distribution = .fillProportionally
        st.alignment = .fill
        return st
    }()
    
    // MARK: - 서브 레이블 - 밤
    let nightLabel: UILabel = {
        let label = UILabel()
        label.text = "GO TO SLEEP"
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .primaryColor400
        return label

    }()

    lazy var nightTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .compact
        picker.tintColor = .primaryColor500
        picker.locale = Locale(identifier: "en_US")
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let date = dateFormatter.date(from: "22:00") {
            picker.date = date
        }
        
        return picker
    }()
    
    lazy var nightStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [nightLabel, nightTimePicker])
        st.spacing = 12
        st.axis = .horizontal
        st.distribution = .fillProportionally
        st.alignment = .fill
        return st
    }()
    
    
    // MARK: - 루틴 스택 뷰
    lazy var routineStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [routineLabel, morningStackView, nightStackView])
        st.spacing = 12
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        return st
    }()
    
  
    
    
    // MARK: - 뒤로가기 버튼
    lazy var submitButton: UIButton = {
        let button = UIButton(type:.custom)
        let iconImage = UIImage(systemName: "chevron.forward.circle")
        let resizedImage = iconImage?.resized(toWidth: 52) // 아이콘 사이즈 설정
        button.setImage(resizedImage, for: .normal)
        button.setImageTintColor(.primaryColor200) // 아이콘 색 설정
        button.isEnabled = false
        return button
    }()
    
    lazy var spinner : UIActivityIndicatorView = {
       let spinner = UIActivityIndicatorView()
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nameTextField.delegate = self
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        backgroundColor = .white
        
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameStackView.leadingAnchor.constraint(equalTo: infoStackView.leadingAnchor, constant: 0),
            nameStackView.trailingAnchor.constraint(equalTo: infoStackView.trailingAnchor, constant: 0),
        ])
        
        underline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            underline.heightAnchor.constraint(equalToConstant: 1),
            underline.widthAnchor.constraint(equalTo: nameTextField.widthAnchor, multiplier: 1 ),
            underline.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            underline.bottomAnchor.constraint(equalTo: nameTextField.bottomAnchor)
        ])
        
        
        addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            infoStackView.heightAnchor.constraint(equalToConstant: viewHeight*2 + padding)
        ])
        
        
        
        cupUnderline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cupUnderline.heightAnchor.constraint(equalToConstant: 1),
            cupUnderline.widthAnchor.constraint(equalTo: cupTextField.widthAnchor, multiplier: 1 ),
            cupUnderline.leadingAnchor.constraint(equalTo: cupTextField.leadingAnchor),
            cupUnderline.bottomAnchor.constraint(equalTo: cupTextField.bottomAnchor)
        ])
        
        
        
        cupStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cupStackView.leadingAnchor.constraint(equalTo: limitStackView.leadingAnchor, constant: 0),
            cupStackView.trailingAnchor.constraint(equalTo: limitStackView.trailingAnchor, constant: 0),
        ])
        
        addSubview(limitStackView)
        limitStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            limitStackView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 40),
            limitStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            limitStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            limitStackView.heightAnchor.constraint(equalToConstant: viewHeight*3 + padding*2)
        ])
        
        addSubview(routineStackView)
        routineStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            routineStackView.topAnchor.constraint(equalTo: limitStackView.bottomAnchor, constant: 40),
            routineStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            routineStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            routineStackView.heightAnchor.constraint(equalToConstant: viewHeight*3 + padding*2)
        ])
        
        addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80),
            submitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
//
//        addSubview(spinner)
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
//            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
//        ])
    }
    

}

extension UIImage {
    func colorImage(with color: UIColor) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        UIGraphicsBeginImageContext(self.size)
        let contextRef = UIGraphicsGetCurrentContext()

        contextRef?.translateBy(x: 0, y: self.size.height)
        contextRef?.scaleBy(x: 1.0, y: -1.0)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)

        contextRef?.setBlendMode(CGBlendMode.normal)
        contextRef?.draw(cgImage, in: rect)
        contextRef?.setBlendMode(CGBlendMode.sourceIn)
        color.setFill()
        contextRef?.fill(rect)

        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return coloredImage
    }
}

extension FirstProfileRoutineView: UITextFieldDelegate {
    // 엔터 눌렀을 대 넘어가는 것
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}
