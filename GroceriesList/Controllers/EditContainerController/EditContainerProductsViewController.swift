//
//  EditContainerProductsViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 27.05.2024.
//

import UIKit

final class EditContainerProductsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var container: Storage = .defaultContainer
    var didUpdateProducts: ([Product]) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Изменить продукты"
        navigationItem.rightBarButtonItem = .init(
            image: UIImage.init(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addNewProduct)
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        didUpdateProducts(container.products)
    }
    
}

private extension EditContainerProductsViewController {
    @objc private func addNewProduct() {
        let newProduct = Product.defaultProduct
        let newIndex = IndexPath(row: container.products.count, section: 0)
        container.products.append(newProduct)
        tableView.insertRows(at: [newIndex], with: .fade)
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: "EditContainerProdsTVCell", bundle: .main), forCellReuseIdentifier: "editProductsCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.tintColor = .clear
        tableView.allowsSelection = true
        tableView.reloadData()
    }
    
}

extension EditContainerProductsViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        container.products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "editProductsCell", for: indexPath) as? EditContainerProdsTVCell else {
                return UITableViewCell()
            }
            
            cell.product = container.products[indexPath.row]
            
            cell.editItem = { [weak self] vc in
                guard let self = self else { return }
                vc.view.backgroundColor = .white
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(
            actions: [
                getSwipeToDeleteAction { [weak self] _, _, _ in
                    guard let self = self else { return }
                    self.container.products.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            ]
        )
    }
}
