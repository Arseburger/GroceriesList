//
//  SearchViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 15.06.2024.
//

import UIKit

final class SearchViewController: UIViewController {
    
    typealias SearchCell = TableView.Cells.searchCell
    typealias EmptyCell = TableView.Cells.nothingFoundCell
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    var container: Storage = .defaultContainer(false) {
        didSet {
            container.sortedProducts = container.products.sorted {
                $0.name <= $1.name
            }
        }
    }
    
    private var hasSearched = false
    
    var filteredProducts: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

private extension SearchViewController {
    func setupNavigationBar() {
        navigationItem.title = "Поиск"
    }
    
    func setupAppearence() {
        setupNavigationBar()
        setupSearchBar()
        configureTableView()
        
//        let dismissKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(dismissKeyboardGestureRecognizer)
    }
    
    func setupSearchBar() {
        searchBar.searchTextField.tintColor = .black
        searchBar.searchTextField.textColor = .black
        searchBar.tintColor = .black
        searchBar.barTintColor = .mainColor
        searchBar.placeholder = "Начните вводить название продукта"
        searchBar.delegate = self
    }
    
    func configureTableView() {
        tableView.register(SearchCell.nib, forCellReuseIdentifier: SearchCell.identifier)
        tableView.register(EmptyCell.nib, forCellReuseIdentifier: EmptyCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.reloadData()
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        !hasSearched ? 0 : filteredProducts.isEmpty ? 1 : filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if filteredProducts.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.identifier, for: indexPath) as? NothingFoundTVCell else {
                return UITableViewCell()
            }
            cell.configure(with: searchBar.text!)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchTVCell else {
                return UITableViewCell()
            }
            let product = filteredProducts[indexPath.row]
            cell.configure(with: product)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard filteredProducts.count > 0 else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let item = filteredProducts[indexPath.row]
        let productVC = ProductViewController()
        productVC.setProduct(product: item)
        navigationController?.pushViewController(productVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        filteredProducts.count == 0 ? nil : indexPath
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        filteredProducts = container.products.filter({
            $0.name.starts(with: searchBar.text!.lowercased())
        })
        hasSearched = true
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.text = ""
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .top
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        hasSearched = true
        filteredProducts = container.products.filter({
            $0.name.starts(with: searchText.lowercased())
        })
        tableView.reloadData()
    }
    
}
