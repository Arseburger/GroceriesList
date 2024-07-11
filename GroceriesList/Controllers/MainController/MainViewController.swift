//
//  MainViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 19.03.2024.
//

import UIKit

final class MainViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    private var containerCell = TableView.Cells.ContainerCell
    private var expiringCell = TableView.Cells.ExpiringProdsCell
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addContainerButton: UIButton!
    @IBOutlet private weak var newContainerTitleTextView: UITextView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var buttonBottomConstraint: NSLayoutConstraint!
    
    @IBAction private func addButtonPressed(_ sender: Any) {
        if isAddingNewContainer {
            if newContainerTitleTextView.hasText {
                addNewContainer(newContainerTitleTextView.text)
            }
        }
        toggleAddingMode()
        
    }
    
    @IBAction private func cancelButtonPressed(_ sender: Any) {
        toggleAddingMode()
    }
    
    private var isAddingNewContainer = false
    var containers: ContainerList = .getEmpty()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
        setupNotifications()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        Storage.counter = containers.containers.count
    }
}

private extension MainViewController {
    func addNewContainer(_ title: String) {
        var container: Storage = .randomContainer()
        container.name = title
        containers.containers.append(container)
        tableView.reloadData()
        tableView.scrollToBottom()
    }
    
    func toggleAddingMode() {
        isAddingNewContainer.toggle()
        
        addContainerButton.setTitle(isAddingNewContainer ? "Подтвердить" : "Добавить контейнер", for: .normal)
        addContainerButton.setImage(.init(systemName:"plus.circle"), for: .normal)
        
        view.endEditing(true)
        tableViewBottomConstraint.constant = isAddingNewContainer ? 52 : 8
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func configureTableView() {
        
        tableView.register(containerCell)
        tableView.register(expiringCell)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.tintColor = .systemGray6
        tableView.separatorStyle = .none
        
        tableView.reloadData()
    }
    
    func setupAppearence() {
        addContainerButton.tintColor = .mainColor
        addContainerButton.setTitle("Добавить контейнер", for: .normal)
        addContainerButton.setTitleColor(.white, for: .normal)
        addContainerButton.layer.cornerRadius = 12
        addContainerButton.setImage(.init(systemName: "plus.circle"), for: .normal)
        
        newContainerTitleTextView.setBorder(color: .mainColor)
        newContainerTitleTextView.text = "Введите название нового хранилища"
        newContainerTitleTextView.layer.cornerRadius = 8
        newContainerTitleTextView.delegate = self
        newContainerTitleTextView.returnKeyType = .done
        newContainerTitleTextView.isScrollEnabled = false
        
        cancelButton.tintColor = .mainColor
        cancelButton.backgroundColor = .white
        cancelButton.layer.cornerRadius = 8
        
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationItem.title = "Список контейнеров"
        navigationItem.backButtonTitle = "Назад"
        
        navigationItem.rightBarButtonItem = .init(
            image: .init(systemName: "gearshape.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(openSettings)
        )
        
        navigationItem.leftBarButtonItem = .init(
            image: .init(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(openSearch)
        )
    }
    
    @objc
    func openSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc
    func openSearch() {
        var prods = [Product]()
        containers.containers.forEach {
            prods.append(contentsOf: $0.products)
        }
        
        let searchVC = SearchViewController()
        searchVC.container = .init(name: "SearchContainer", image: nil, products: prods, shoulGetNewId: false)
        navigationController?.pushViewController(searchVC, animated: true)
    }
}

extension MainViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section > 0 ? containers.containers.count : 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
                
            case 0:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: expiringCell.identifier,
                    for: indexPath
                ) as? ExpiringProductsTVCell else {
                    return UITableViewCell()
                }
                
                var number: Int = 0
                if containers.containers.isEmpty {
                    number = -1
                } else {
                    containers.containers.forEach({
                        number += $0.expiringProducts.count
                    })
                }
                
                cell.getRotts(number)
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: containerCell.identifier,
                    for: indexPath
                ) as? ContainerTVCell else {
                    return UITableViewCell()
                }
                cell.configure(with: containers.containers[indexPath.row])
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
                
            case 0:
                if containers.containers.isEmpty { return }
                let expProducts = containers.getExpProds().sorted {
                    $0.expDate <= $1.expDate
                }
                let expContainer = Storage(name: "Просрочка", image: nil, products: expProducts, shoulGetNewId: false)
                let expiringVC = ExpiringProductsViewController()
                expiringVC.container = expContainer
                navigationController?.pushViewController(expiringVC, animated: true)
                
            default:
                let detailVC = ContainerViewController()
                detailVC.container = containers.containers[indexPath.row]
                detailVC.updateContainer = { [weak self] container in
                    guard let self = self else { return }
                    self.containers.containers[indexPath.row] = container
                    self.tableView.reloadData()
                    Storage.counter = self.containers.containers.count
                }
                navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.section > 0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        .init(
            actions: [
                getSwipeToDeleteAction { [weak self] _, _, _ in
                    guard let self = self else { return }
                    self.containers.containers.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)}
            ]
        )
    }
}

private extension MainViewController {
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {
        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height - view.safeAreaInsets.bottom
        
        buttonBottomConstraint.constant = -keyboardHeight - 8
        UIView.animate(withDuration: 0) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
    }
    
    @objc
    private func keyboardWillDisappear(notification: NSNotification?) {
        
        buttonBottomConstraint.constant = -8
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        UIView.animate(withDuration: 0, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
}

extension MainViewController: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidChange(_ textView: UITextView) {
        addContainerButton.isEnabled = textView.hasText
        textView.setBorder(color: textView.hasText ? .mainColor : .red)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.hasText {
            textView.text = "Введите название нового хранилища"
            addContainerButton.isEnabled = true
            textView.setBorder(color: .mainColor)
        }
    }
}
