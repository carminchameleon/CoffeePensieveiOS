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
        addCompletionHandlers()
    }

    func addCompletionHandlers() {
        
        viewModel.onDrinkCompleted = {[weak self] sectionList in
            DispatchQueue.main.async {
                self?.updateView.tableView.reloadData()
            }
        }
        
        viewModel.submitAvailable.addObserver { [weak self] isEnable in
            DispatchQueue.main.async {
                self?.navigationItem.rightBarButtonItem?.isEnabled = isEnable
            }
        }
        
        viewModel.memo.addObserver {[weak self] memo in
            DispatchQueue.main.async {
                self?.updateView.tableView.reloadData()
            }
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = viewModel.naviagtionTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationController?.navigationBar.tintColor = .primaryColor500
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.submitAvailable.value
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
        viewModel.handleDoneButtonTapped(currentVC: self)
    }
}

extension UpdateViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellWidth = tableView.frame.size.width - 12 - 40
        let memoHeight = Common.heightForView(text: viewModel.memo.value, font: FontStyle.callOut, width: cellWidth)
        let number = min(60, memoHeight)
        if indexPath.section == 1 {
            return viewModel.memo.value.isEmpty ? 40 : number + 20
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
        headerView.titleLabel.font = FontStyle.subhead
        headerView.titleLabel.textColor = .black
        headerView.button.isHidden = true
        headerView.titleLabel.text = section == 0 ? "" : "Your memo"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = viewModel.getRowData(index: indexPath.row)
        switch indexPath.section {
        case 0:
            if rowData.title == "Tags" || rowData.title == "Feeling" {
                return getPageCell(tableView: tableView, indexPath: indexPath)
            } else {
                return getModalCell(tableView: tableView, indexPath: indexPath)
            }
        case 1:
            return getMemoCell(tableView: tableView, indexPath: indexPath)
        default:
        fatalError("Invalid section")

        }
    }
    
    func getModalCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let rowData = viewModel.getRowData(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId.updateCell.rawValue, for: indexPath) as! UpdateTableViewCell
        cell.cellData = rowData
        cell.accessoryType = .none
        cell.cellTrailingMarginConstraint.constant = -12
        return cell
    }
    
    func getPageCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let rowData = viewModel.getRowData(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId.updateCell.rawValue, for: indexPath) as! UpdateTableViewCell
        cell.cellData = rowData
        cell.accessoryType = .disclosureIndicator
        cell.cellTrailingMarginConstraint.constant = -40
        return cell
    }
    
    func getMemoCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId.noteCell.rawValue, for: indexPath) as! NoteTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.noteText = viewModel.memo.value
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.handleSelectedRow(rowIndex: indexPath.row, currentVC: self)
        } else {
            viewModel.handleSelectedNote(currentVC: self)
        }
    }
}

