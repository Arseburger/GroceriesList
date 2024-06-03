//
//  MainViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 19.03.2024.
//

import UIKit

final class MainViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addContainerButton: UIButton!
    
    private var containers: ContainerList = .defaultItem {
        didSet {
        }
    }
    
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
    }
    
}

private extension MainViewController {
    
    func configureTableView() {
        tableView.register(
            UINib(
                nibName: "ContainerTVCell",
                bundle: .main
            ),
            forCellReuseIdentifier: "containerTVCell"
        )
        
        tableView.register(
            UINib(
                nibName: "ExpiringProductsTVCell",
                bundle: .main
            ),
            forCellReuseIdentifier: "expiredTVCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.tintColor = .clear
        tableView.separatorStyle = .none
        
        tableView.reloadData()
    }
    
    func setupAppearence() {
        addContainerButton.tintColor = UIColor.mainColor
        addContainerButton.setTitle("Изменить остатки", for: .normal)
        addContainerButton.setTitleColor(.white, for: .normal)
        addContainerButton.layer.cornerRadius = 12
        
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationItem.title = "Список контейнеров"
        navigationItem.backButtonTitle = "Назад"
    }
    
}

extension MainViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return containers.hasExpiringProducts ? 1 : 0
        } else {
            return containers.containers.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        containers.hasExpiringProducts ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch indexPath.section {
                case 0:
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "expiredTVCell",
                        for: indexPath
                    ) as? ExpiringProductsTVCell else {
                        return UITableViewCell()
                    }
                    var number: Int = 0
                    containers.containers.forEach({ item in
                        number += item.expiredProducts.count
                    })
                    cell.getRotts(number)
                    return cell
                default:
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "containerTVCell",
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
                let vc = UIViewController()
                goTo(vc, with: "Просрочка")
            default:
                let detailVC = ContainerViewController()
                detailVC.container = containers.containers[indexPath.row]
                navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.section > 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print(containers.containers.count)
        return .init(actions: [.init(style: .destructive, title: "Удалить", handler: { [weak self] _, _, _ in
            guard let self = self else { return }
            guard self.containers.containers.count > 1 else {
                return
            }
            self.containers.containers.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        })])
    }
    
}
