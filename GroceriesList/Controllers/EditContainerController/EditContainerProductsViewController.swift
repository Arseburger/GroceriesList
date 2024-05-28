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
    var didUpdateProduct: (([Product]) -> Void)? = { _ in }
    
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
    
    @objc private func toggleTableViewEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }

}

private extension EditContainerProductsViewController {
    
    func configureTableView() {
        tableView.register(
            EditContainerProdsTVCell.self,
            forCellReuseIdentifier: EditContainerProdsTVCell.identifier
        )
        tableView.register(
            TwoButtonedTVCell.self,
            forCellReuseIdentifier: TwoButtonedTVCell.identifier
        )
        
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
        60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditContainerProdsTVCell.identifier, for: indexPath) as? EditContainerProdsTVCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .randomColor()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil {
            print(indexPath.row + 1)
        }
    }
}
