//
//  EditContainerProductsViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 27.05.2024.
//

import UIKit

final class EditContainerProductsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    private var editCell = TableView.Cells.EditContainerCell
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var quantityTextView: UITextView!
    @IBOutlet private weak var quantityStepper: UIStepper!
    @IBOutlet private weak var updateQuantityButton: UIButton!
    @IBOutlet private weak var stackBottomConstraint: NSLayoutConstraint!
    
    
    @IBAction private func updateQuantityButtonPressed(_ sender: Any) {
        guard selectedIndex != -1 else { return }
        let qty = container.products[selectedIndex].quantity
        container.products[selectedIndex].quantity -= quantityStepper.value >= qty
        ? qty
        : Double(quantityTextView.text ?? "") ?? quantityStepper.value
        tableView.reloadData()
    }
    
    var container: Storage = .defaultContainer(false)
    var didUpdateProducts: ([Product]) -> Void = { _ in }
    var selectedIndex: Int = -1 {
        didSet {
            tableView.scrollToRow(at: IndexPath(row: selectedIndex, section: 0), at: .middle, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
        setupNotifications()
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
        let newProduct = Product.randomProduct()
        let newIndex = IndexPath(row: container.products.count, section: 0)
        container.products.append(newProduct)
        tableView.insertRows(at: [newIndex], with: .fade)
        tableView.scrollToRow(at: newIndex, at: .bottom, animated: true)
    }
    
    func setupAppearence() {
        quantityTextView.setBorder(color: .mainColor)
        quantityTextView.layer.cornerRadius = quantityTextView.frame.height * 0.2
        quantityTextView.textContainer.maximumNumberOfLines = 1
        quantityTextView.keyboardType = .decimalPad
        quantityTextView.isScrollEnabled = false
        quantityTextView.text = NSString(format:"%.2f", quantityStepper.value).standardizingPath
        
        updateQuantityButton.layer.cornerRadius = updateQuantityButton.frame.height * 0.2
        updateQuantityButton.backgroundColor = .mainColor
        updateQuantityButton.setTitle("Изменить", for: .normal)
        updateQuantityButton.setTitleColor(.white, for: .normal)
        updateQuantityButton.setTitleColor(.systemGray4, for: .highlighted)
        
        quantityStepper.value = 1.0
        quantityStepper.stepValue = 0.1
        quantityStepper.addTarget(self, action: #selector(updateValue), for: .valueChanged)
    }
    
    func configureTableView() {
        tableView.register(editCell)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        tableView.tintColor = .clear
        tableView.allowsSelection = true
        tableView.reloadData()
    }
    
    @objc
    private func updateValue() {
        quantityTextView.text = NSString(format:"%.2f", quantityStepper.value).standardizingPath
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
        
        stackBottomConstraint.constant = keyboardHeight + 8
        UIView.animate(withDuration: 0) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func keyboardWillDisappear(notification: NSNotification?) {
        
        stackBottomConstraint.constant = 8
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        UIView.animate(withDuration: 0, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: editCell.identifier, for: indexPath) as? EditContainerProdsTVCell else {
            return UITableViewCell()
        }
        
        cell.product = container.products[indexPath.row]
        
        cell.editItem = { [weak self] _ in
            guard let self = self else { return }
            self.tableView.indexPathsForVisibleRows?.forEach {
                if let cell = self.tableView.cellForRow(at: $0) as? EditContainerProdsTVCell {
                    cell.setBorder(color: UIColor.clear)
                }
            }
            
            cell.setBorder(color: .mainColor)
            self.selectedIndex = indexPath.row
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return .init(
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
