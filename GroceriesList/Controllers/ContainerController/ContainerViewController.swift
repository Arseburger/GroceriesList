//
//  ContainerViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 19.03.2024.
//

import UIKit

final class ContainerViewController: UIViewController {

    var container: Storage = .init(name: "HUESOS", image: nil, products: [])
    
    private enum Constants {
        static let itemsPerRow: Int = 2
        static let hPadding: CGFloat = 8.0
        static let vPadding: CGFloat = 8.0
    }
    
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var addItemsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
        setupCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        topView.backgroundColor = .mainColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

private extension ContainerViewController {
    
    func setupCollectionView() {
        collectionView.register(
            UINib(
                nibName: "DetailItemCollectionViewCell",
                bundle: .main
            ),
            forCellWithReuseIdentifier: "productCell"
        )
        
        collectionView.register(
            UINib(
                nibName: "AddNewItemCollectionViewCell",
                bundle: .main
            ),
            forCellWithReuseIdentifier: "newProductCell"
        )
        
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
        navigationController?.setupNavigationBar()
        navigationItem.title = container.name
    }
}

extension ContainerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        container.products.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = collectionView.frame
        let side = (frame.width - 3 * Constants.hPadding) / CGFloat(Constants.itemsPerRow)
        
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? DetailItemCollectionViewCell else {
                return UICollectionViewCell()
            }
            let item = container.products[indexPath.item]
            cell.configure(with: item)
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newProductCell", for: indexPath) as? AddNewItemCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        let vc = UIViewController()
        let frame = vc.view.frame
        let width: CGFloat = 200, height: CGFloat = 40
        vc.view.backgroundColor = .white
        
        if index < container.products.count {
            let item = container.products[index]
            let nameLabel: UILabel = UILabel(
                frame: .init(
                    origin: .init(
                        x: frame.midX - width / 2.0,
                        y: frame.midY - height
                    ),
                    size: .init(
                        width: width,
                        height: height
                    )
                )
            )
            
            let infoLabel: UILabel = UILabel(
                frame: .init(
                    origin: .init(
                        x: frame.midX - width / 2.0,
                        y: frame.midY - height / 2.0
                    ),
                    size: .init(
                        width: width,
                        height: height * 2.0
                    )
                )
            )
            infoLabel.numberOfLines = 3
            
            nameLabel.text = item.name
            infoLabel.text = "\(item.expDate!) \(item.quantity) \(item.measureUnit.full!)"
            [nameLabel, infoLabel].forEach { label in
                label.textAlignment = .center
                label.textColor = .black
                vc.view.addSubview(label)
            }
            vc.view.layoutSubviews()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            goTo(vc, with: "New product")
        }
        
        
    }
    
}
