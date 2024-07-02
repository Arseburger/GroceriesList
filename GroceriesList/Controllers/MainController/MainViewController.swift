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
    
    @IBAction private func addButtonPressed(_ sender: Any) {
        containers.containers.append(.randomContainer())
        tableView.reloadData()
        let lastIndex = IndexPath(row: containers.containers.count - 1, section: 1)
        tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
    }
    
    var containers: ContainerList = ContainerList.randomItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
        configureTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        Storage.counter = containers.containers.count
    }
    
}

private extension MainViewController {
    
    func configureTableView() {
        
        tableView.register(containerCell)
        tableView.register(expiringCell)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.tintColor = .clear
        tableView.separatorStyle = .none
        
        tableView.reloadData()
    }
    
    func setupAppearence() {
        addContainerButton.tintColor = .mainColor
        addContainerButton.setTitle("Добавить контейнер", for: .normal)
        addContainerButton.setTitleColor(.white, for: .normal)
        addContainerButton.layer.cornerRadius = 12
        addContainerButton.setImage(.init(systemName: "plus"), for: .normal)
        
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
        let searchVC = SearchViewController()
        
        var prods = [Product]()
        containers.containers.forEach {
            prods.append(contentsOf: $0.products)
        }
        
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
                let expiringVC = ExpiringProductsViewController()
                let expProducts = containers.getExpProds().sorted {
                    $0.expDate <= $1.expDate
                }
                let expContainer = Storage(name: "Просрочка", image: nil, products: expProducts, shoulGetNewId: false)
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
        indexPath.section > 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        getSwipeToDeleteAction { [weak self] _, _, _ in
            guard let self = self else { return }
            self.containers.containers.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)}
    }
    
}
