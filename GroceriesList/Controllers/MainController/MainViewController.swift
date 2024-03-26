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
    @IBOutlet private weak var navigationBar: UIView!
    
    private var containers: ContainerList = .defaultItem
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
        configureTableView()
    }
    
}

private extension MainViewController {
    
    func configureTableView() {
        tableView.register(UINib(nibName: "ContainerTVCell", bundle: .main), forCellReuseIdentifier: "containerTVCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
    
    func setupAppearence() {
        addContainerButton.tintColor = UIColor.mainColor
        addContainerButton.setTitle("Добавить хранилище", for: .normal)
        addContainerButton.setTitleColor(.white, for: .normal)
        addContainerButton.layer.cornerRadius = 12
        navigationBar.backgroundColor = UIColor.mainColor
    }
    
}

extension MainViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "containerTVCell",
            for: indexPath
        ) as? ContainerTVCell else {
            return UITableViewCell()
        }
        cell.configure(with: Storage.defaultContainer)
        return cell
    }
}
