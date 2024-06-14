//
//  ExpiringProductsViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 10.06.2024.
//

import UIKit

class ExpiringProductsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var container: Storage = .defaultContainer {
        didSet {
            Storage.counter -= 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        print(container.expiringProducts.count, container.expiredProducts.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Просрочка"
    }

}

private extension ExpiringProductsViewController {

    func configureTableView() {
        
        tableView.register(UINib(nibName: "ExpiredProductTVCell", bundle: .main), forCellReuseIdentifier: "expiredProductCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.reloadData()
    }
}

extension ExpiringProductsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        container.expiringProducts.isEmpty
        ? container.expiredProducts.isEmpty ? 0 : 1
        : container.expiredProducts.isEmpty ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if container.expiringProducts.isEmpty && section == 0 {
            return container.expiredProducts.isEmpty
            ? 0
            : container.expiredProducts.count
        } else {
            if section == 0 {
                return container.expiringProducts.count
            } else {
                return container.expiredProducts.isEmpty ? 0 : container.expiredProducts.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        32
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return container.expiringProducts.isEmpty
            ? "Просроченные продукты (\(container.expiredProducts.count))"
            : "Испорятся в течение трёх дней (\(container.expiringProducts.count))"
        } else {
            return "Просроченные продукты (\(container.expiredProducts.count))"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expiredProductCell", for: indexPath) as? ExpiredProductTVCell else {
            return UITableViewCell()
        }
        var product: Product
        
        if indexPath.section == 0 {
            product = container.expiringProducts.isEmpty
            ? container.expiredProducts[indexPath.row]
            : container.expiringProducts[indexPath.row]
        } else {
            product = container.expiredProducts[indexPath.row]
        }
        cell.item = product
        return cell
    }
    
}
