//
//  SearchViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 15.06.2024.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private var searchCell = TableView.Cells.SearchCell
    private var emptyCell = TableView.Cells.NothingFoundCell
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private var hasSearched = false
    
    var filteredProducts: [Product] = []
    var container: Storage = .defaultContainer(false) {
        didSet {
            container.sortedProducts = container.products.sorted {
                $0.name <= $1.name
            }
        }
    }
    
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
        setupNotifications()
    }
    
    func setupSearchBar() {
        searchBar.placeholder = "Начните вводить название продукта"
        searchBar.delegate = self
    }
    
    func configureTableView() {
        tableView.register(searchCell)
        tableView.register(emptyCell)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.reloadData()
    }
    
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
        tableView.contentInset = .init(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        tableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        UIView.animate(withDuration: 0, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        UIView.animate(withDuration: 0, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        !hasSearched ? 0 : filteredProducts.isEmpty ? 1 : filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if filteredProducts.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: emptyCell.identifier, for: indexPath) as? NothingFoundTVCell else {
                return UITableViewCell()
            }
            cell.configure(with: searchBar.text!)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: searchCell.identifier, for: indexPath) as? SearchTVCell else {
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
            $0.name.lowercased().starts(with: searchText.lowercased())
        })
        tableView.reloadData()
    }
    
}
