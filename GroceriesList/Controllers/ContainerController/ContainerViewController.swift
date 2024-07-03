//
//  ContainerViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 19.03.2024.
//

import UIKit

final class ContainerViewController: UIViewController {
    
    private var newItemCell = CollectionView.Cells.newItemCell
    private var detailItemCell = CollectionView.Cells.detailItemCell
    
    var container: Storage = .defaultContainer(false)
    
    var updateContainer: (Storage) -> Void = { _ in }
    
    private enum Constants {
        static let itemsPerRow: Int = 2
        static let hPadding: CGFloat = 8.0
        static let vPadding: CGFloat = 8.0
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addItemsButton: UIButton!
    
    @IBAction private func editProductsButtonPressed(_ sender: Any) {
        let editProductsVC = EditContainerProductsViewController()
        editProductsVC.container = self.container
        
        editProductsVC.didUpdateProducts = { [weak self] products in
            guard let self = self else { return }
            self.container.products = products.sorted(by: {
                $0.expDate > $1.expDate
            })
            self.collectionView.reloadData()
            
        }
        navigationController?.pushViewController(editProductsVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = .init(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            menu: UIMenu(title: "", children: configureActions())
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateContainer(container)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        container.sortedProducts = container.products
    }
    
}

private extension ContainerViewController {
    
    func handler(for action: UIAction) {
        switch action.identifier.rawValue {
            case "1":
                container.sortedProducts = container.products.sorted {
                    $0.expDate > $1.expDate
                }
                collectionView.reloadData()
            case "2":
                container.sortedProducts = container.products.sorted {
                    $0.name < $1.name
                }
                collectionView.reloadData()
            default:
                container.sortedProducts = container.products
                collectionView.reloadData()
        }
    }
    
    func configureActions() -> [UIAction] {
        var actions: [UIAction] = []
        let sortByDateAction: UIAction = UIAction(title: "Срок годности", identifier: .init("1"), handler: handler)
        let sortByNameAction: UIAction = UIAction(title: "Название", identifier: .init("2"), handler: handler)
        actions = [sortByDateAction, sortByNameAction]
        return actions
    }
    
    func setupCollectionView() {
        
        [newItemCell, detailItemCell].forEach {
            collectionView.register($0)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let hInset = Constants.hPadding
        let vInset = Constants.vPadding
        collectionView.contentInset = .init(top: vInset, left: hInset, bottom: vInset, right: hInset)
        collectionView.isScrollEnabled = true
        collectionView.reloadData()
    }
    
    func setupAppearence() {
        addItemsButton.tintColor = UIColor.mainColor
        addItemsButton.setTitle("Изменить остатки", for: .normal)
        addItemsButton.setTitleColor(.white, for: .normal)
        addItemsButton.layer.cornerRadius = 12
        navigationItem.title = container.name
        navigationItem.backButtonTitle = "Назад"
    }
    
}

extension ContainerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        container.products.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = collectionView.frame
        let side = (frame.width - CGFloat((Constants.itemsPerRow + 1)) * Constants.hPadding) / CGFloat(Constants.itemsPerRow)
        
        return .init(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.vPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.hPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item < container.products.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailItemCell.identifier, for: indexPath) as? DetailItemCollectionViewCell else {
                return UICollectionViewCell()
            }
            let item = container.sortedProducts[indexPath.item]
            cell.configure(with: item)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newItemCell.identifier, for: indexPath) as? AddNewItemCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        
        if index < container.products.count {
            let item = container.sortedProducts[index]
            let productVC = ProductViewController()
            productVC.setProduct(product: item)
            navigationController?.pushViewController(productVC, animated: true)
        } else {
            let vc = NewProductViewController()
            vc.containerId = self.container.id
            vc.addNewProduct = { [weak self] product in
                guard let self = self else { return }
                self.container.products.append(product)
                self.container.products.sort(by: {
                    $0.expDate > $1.expDate
                })
                self.collectionView.insertItems(at: [IndexPath(item: self.container.products.count - 1, section: 0)])
                self.collectionView.reloadData()
                
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
