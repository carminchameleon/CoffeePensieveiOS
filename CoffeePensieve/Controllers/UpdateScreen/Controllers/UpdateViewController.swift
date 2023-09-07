//
//  UpdateViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/05.
//

import UIKit

final class UpdateViewController: UIViewController {

    private let updateView = UpdateView()
    let viewModel: UpdateViewModel
    
    init(viewModel: UpdateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = updateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        configureTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.onDrinkCompleted = {[weak self] sectionList in
            DispatchQueue.main.async {
                self?.updateView.tableView.reloadSections([0], with: .automatic)
            }
        }
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.updateView.tableView.reloadSections([1], with: .automatic)
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = viewModel.naviagtionTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationController?.navigationBar.tintColor = .primaryColor500
    }
    
    private func configureTable() {
        updateView.tableView.delegate = self
        updateView.tableView.dataSource = self
        
        updateView.tableView.register(UpdateTableViewCell.self, forCellReuseIdentifier: CellId.updateCell.rawValue)
        updateView.tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: CellId.noteCell.rawValue)
        updateView.tableView.register(TrackerTodayHeaderView.self, forHeaderFooterViewReuseIdentifier: CellId.trackerTodayHeader.rawValue)
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func saveButtonTapped() {
        print("save Button Tapped")
    }
}


extension UpdateViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellWidth = tableView.frame.size.width - 12 - 40
        let memoHeight = Common.heightForView(text: viewModel.memo, font: FontStyle.callOut, width: cellWidth)
        let number = min(60, memoHeight)
        if indexPath.section == 1 {
            return viewModel.memo.isEmpty ? 40 : number + 20
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 24 : 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellId.trackerTodayHeader.rawValue) as! TrackerTodayHeaderView
        headerView.titleLabel.font = FontStyle.headline
        headerView.titleLabel.textColor = .black
        headerView.button.isHidden = true
        headerView.titleLabel.text = section == 0 ? "" : "Your memo"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let rowData = viewModel.drinkDetail[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId.updateCell.rawValue, for: indexPath) as! UpdateTableViewCell
            // TODO: - VM으로 바꿔서 넣어야 하는 것 나중에 작업
            cell.cellData = rowData
            if rowData.title == "Tags" {
                cell.accessoryType = .disclosureIndicator
                cell.cellTrailingMarginConstraint.constant = -40
            } else {
                cell.accessoryType = .none
                cell.cellTrailingMarginConstraint.constant = -12
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId.noteCell.rawValue, for: indexPath) as! NoteTableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.noteText = viewModel.memo
            return cell
        default:
        fatalError("Invalid section")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.handleSelectedRow(rowIndex: indexPath.row, currentVC: self)
        } else {
            viewModel.handleSelectedNote(currentVC: self)
        }
    }
}


class HeaderView: UITableViewHeaderFooterView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontStyle.title2
        label.textColor = .primaryColor500
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        // 헤더 뷰 설정
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .white
        
        // 타이틀 레이블 설정
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
        ])
    }

   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}
