//
//  ProductViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 25.05.2024.
//

import UIKit

final class ProductViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var expDateLabel: UILabel!
    
    var product: Product = .init(name: "Жопа", expDate: "19/07/2029", quantity: 1.5, image: UIImage(systemName: "pencil"), measureUnit: ("плн", "полная"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configure() {
        if let image = product.image {
            imageView.image = image
        }
        nameLabel.text = product.name
        
        quantityLabel.attributedText = String.makeAttrLabelText("Количество: ", postfix: "\(product.quantity) \(product.measureUnit.full!)")
        
        expDateLabel.attributedText = String.makeAttrLabelText("Срок годности: ", postfix: "\(product.expDate?.formatted(date: .numeric, time: .omitted) ?? Date.now.formatted(date: .numeric, time: .omitted))")
    }

    func setProduct(product: Product?) {
        if let prod = product {
            self.product = prod
        }
    }
    
}
