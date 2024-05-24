//
//  ContainerViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 19.03.2024.
//

import UIKit

final class ContainerViewController: UIViewController {

    var container: Storage = .defaultContainer
    
    private enum Constants {
        static let itemsPerRow: Int = 3
        static let hPadding: CGFloat = 8.0
        static let vPadding: CGFloat = 16.0
    }
    
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addItemsButton: UIButton!
    
    var itemsList: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        addNavigationBarAddButton()
    }
    
}

private extension ContainerViewController {
    func setupCollectionView() {
        
        collectionView.register(UINib(nibName: "DetailItemCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: DetailItemCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "AddNewItemCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: AddNewItemCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 4, left: 8, bottom: 0, right: 0)
        collectionView.reloadData()
    }
    
    func setupAppearence() {
        addItemsButton.tintColor = UIColor.mainColor
        addItemsButton.setTitle("Изменить остатки", for: .normal)
        addItemsButton.setTitleColor(.white, for: .normal)
        addItemsButton.layer.cornerRadius = 12
        topView.backgroundColor = .mainColor
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.backgroundColor = .mainColor
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = container.name
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}

extension ContainerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemsList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = collectionView.frame
        let side = (frame.width - 2 * Constants.vPadding) / CGFloat(Constants.itemsPerRow + 1)
        
        return .init(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.hPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.vPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < itemsList.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailItemCollectionViewCell.identifier, for: indexPath) as? DetailItemCollectionViewCell else {
                return UICollectionViewCell()
            }
            let item = itemsList[indexPath.item]
            print(item)
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewItemCollectionViewCell.identifier, for: indexPath) as? AddNewItemCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
}
