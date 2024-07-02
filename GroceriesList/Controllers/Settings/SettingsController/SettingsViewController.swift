//
//  SettingsViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 21.06.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var measureUnitCell = TableView.Cells.SettingsMeasureUnitCell
    
    private enum Constants {
        static let mUCellHeight = CGFloat(32)
        static let headerHeight = CGFloat(28)
        static let footerHeight = CGFloat(40)
        static let interSectionSpace = CGFloat(8)
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeightContsraint: NSLayoutConstraint!
    
    private var MUStorage = MeasureUnitStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Настройки"
    }
}

private extension SettingsViewController {
    
    func updateTableViewHeight() {
        let height = CGFloat(MUStorage.units.count) * Constants.mUCellHeight + Constants.headerHeight + Constants.footerHeight + Constants.interSectionSpace
        tableViewHeightContsraint.constant = height
        updateViewConstraints()
    }
    
    func setupAppearence() {
        configureTableView()
    }
    
    func configureTableView() {
        tableView.register(measureUnitCell)
        tableView.sectionHeaderTopPadding = Constants.interSectionSpace
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        updateTableViewHeight()
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.mUCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        Constants.footerHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MUStorage.units.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: measureUnitCell.identifier, for: indexPath) as? SettingsMUTVCell else {
            return UITableViewCell()
        }
        cell.configure(with: MUStorage.units[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = MUStorage.units[indexPath.row]
        let vc = EditSettingsItemsViewController()
        vc.set(item: item, state: .edit)
        vc.didUpdateItem = { [weak self] unit in
            self?.MUStorage.units[indexPath.row] = unit
            self?.tableView.reloadData()
        }
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SettingsHeader(reuseIdentifier: SettingsHeader.identifier)
        header.setTitle("Единицы измерения")
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let footer = SettingsFooter(reuseIdentifier: SettingsFooter.identifier)
        footer.setTitle("✚ Добавить")
        
        footer.addNewItem = { [weak self] vc, unit in
            
            vc.didAddItem = { unit in
                self?.MUStorage.units.append(unit)
                self?.tableView.reloadData()
                self?.updateTableViewHeight()
            }
            
            self?.present(vc, animated: true)
        }
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        getSwipeToDeleteAction { [weak self] _, _,_ in
            self?.MUStorage.units.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
}

