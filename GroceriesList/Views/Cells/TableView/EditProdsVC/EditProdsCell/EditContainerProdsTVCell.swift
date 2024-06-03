//
//  EditContainerProdsTVCell.swift
//  GroceriesList
//
//  Created by Александр Королёв on 27.05.2024.
//

import UIKit

class EditContainerProdsTVCell: UITableViewCell {

    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var measureUnitLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var bottomView: UIView!
    
    @IBAction private func editButtonPressed(_ sender: Any) {
        editItem(UIViewController())
        print("edit")
    }
    
    var product: Product = .init(name: "gâteau", expDate: "28/4/2029", quantity: 2, image: .init(systemName: ""), measureUnit: ("кусок", "кус")) {
        didSet {
            configure()
        }
    }
    
    var editItem: (UIViewController) -> Void = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearence()
        selectionStyle = .none
    }

    private func setupAppearence() {
        [quantityLabel, measureUnitLabel].forEach { label in
            label?.textColor = .black
        }
        nameLabel.font = .boldSystemFont(ofSize: 18)
        quantityLabel.font = .systemFont(ofSize: 10)
        measureUnitLabel.font = .systemFont(ofSize: 10)
        measureUnitLabel.numberOfLines = 2
        quantityLabel.numberOfLines = 2
        editButton.tintColor = .systemGray4
        productImageView.tintColor = .red
        bottomView.layer.cornerRadius = bottomView.frame.height * 0.1
    }
    
    func configure() {
        nameLabel.text = product.name
        quantityLabel.text = "Количество: \n\(product.quantity)"
        measureUnitLabel.text = "Единица измерения: \n\(product.measureUnit.full!) (\(product.measureUnit.short!))"
        if let image = product.image {
            productImageView.image = image
        }
    }
    
}
