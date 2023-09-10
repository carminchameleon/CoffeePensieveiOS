//
//  TagViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/06.
//

import UIKit

protocol TagControlDelegate: AnyObject {
    func tagSelected(tagIds: [Int])
}

final class TagViewController: UIViewController {
    let updateView = UpdateView()
    var viewModel: TagViewModel
    
    weak var delegate: TagControlDelegate?
    
    init(viewModel: TagViewModel) {
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
        configureTableView()
        viewModel.onRowCompleted = {[weak self] row in
            DispatchQueue.main.async {
                let selectedIndexPath = IndexPath(item:row , section: 0)
                self?.updateView.tableView.reloadRows(at: [selectedIndexPath], with: .fade)
            }
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = "Tags"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureTableView() {
        updateView.tableView.delegate = self
        updateView.tableView.dataSource = self
        updateView.tableView.register(TagTableViewCell.self, forCellReuseIdentifier: CellId.tagCell.rawValue)
    }
    
    @objc func doneButtonTapped() {
        delegate?.tagSelected(tagIds: viewModel.selectedTagIdList)
        navigationController?.popToRootViewController(animated: true)
    }
}

extension TagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId.tagCell.rawValue, for: indexPath) as! TagTableViewCell
        
        cell.dataLabel.text = viewModel.getCellLabelText(index: indexPath.row)
        let isSelected = viewModel.getCellCheckStatus(index: indexPath.row)
        cell.tintColor = .primaryColor500
        cell.accessoryType = isSelected ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.handleSelectedRow(index: indexPath.row, currentVC: self)
    }
}


