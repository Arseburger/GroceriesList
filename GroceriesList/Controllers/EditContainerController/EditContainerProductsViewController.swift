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
            image: UIImage.init(systemName: "pencil"),
            style: .plain,
            target: self,
            action: #selector(toggleTableViewEditing)
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        didUpdateProducts(container.products)
    }
    
    @objc private func toggleTableViewEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        tableView.reloadRows(at: [IndexPath(row: container.products.count, section: 0)], with: .automatic)
    }

}

private extension EditContainerProductsViewController {
    
    func configureTableView() {
        tableView.register(UINib(nibName: "EditContainerProdsTVCell", bundle: .main), forCellReuseIdentifier: "editProductsCell")
        tableView.register(UINib(nibName: "TwoButtonedTVCell", bundle: .main), forCellReuseIdentifier: "twoButtonsCell")
        
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
        container.products.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < container.products.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "editProductsCell", for: indexPath) as? EditContainerProdsTVCell else {
                return UITableViewCell()
            }
            let index = indexPath.row
            cell.product = container.products[index]
            
            cell.editItem = { [weak self] vc in
                guard let self = self else { return }
                vc.view.backgroundColor = .white
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "twoButtonsCell", for: indexPath) as? TwoButtonedTVCell else {
                return UITableViewCell()
            }
            
            cell.isHidden = !tableView.isEditing
            
            cell.addNewProduct = { [weak self] in
                guard let self = self else { return }
                let newProduct = Product.defaultProduct
                let newIndex = IndexPath(row: self.container.products.count, section: 0)
                self.container.products.append(newProduct)
                self.tableView.insertRows(at: [newIndex], with: .none)
            }
            
            return cell
        }
    }
    
}
