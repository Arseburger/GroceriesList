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
    @IBOutlet private weak var topView: UIView!
    
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
        topView.backgroundColor = .mainColor
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
        tableView.contentInset = .init(top: 4, left: 0, bottom: 0, right: 0)
        
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
        navigationController?.navigationBar.backgroundColor = .mainColor
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Список контейнеров"
        navigationItem.backButtonTitle = "Назад"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
}

extension MainViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        containers.containers.count + (containers.hasExpiringProducts ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if containers.hasExpiringProducts {
            switch indexPath.row {
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
                    cell.configure(with: containers.containers[indexPath.row - 1])
                    return cell
            }
        } else {
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
        let index = indexPath.row - (containers.hasExpiringProducts ? 1 : 0)
        switch indexPath.row {
            case 0:
                if !containers.hasExpiringProducts {
                    let detailVC = ContainerViewController()
                    detailVC.container = containers.containers[index]
                    navigationController?.pushViewController(detailVC, animated: true)
                } else {
                    let vc = UIViewController()
                    goTo(vc, with: "Просрочка")
                }
            default:
                let detailVC = ContainerViewController()
                detailVC.container = containers.containers[index]
                navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}
