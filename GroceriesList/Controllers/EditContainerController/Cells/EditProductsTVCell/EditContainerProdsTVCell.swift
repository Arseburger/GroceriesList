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
    }
    
    var product: Product = .randomProduct() {
        didSet {
            configure()
        }
    }
    
    var editItem: (UIViewController) -> Void = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        setupAppearence()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        bottomView.setBorder(width: isHighlighted ? 1.0 : 0.0, color: .mainColor)
    }

    private func setupAppearence() {
        [quantityLabel, measureUnitLabel].forEach { label in
            label?.textColor = .black
        }
        nameLabel.font = .boldSystemFont(ofSize: 20)
        quantityLabel.font = .systemFont(ofSize: 12)
        measureUnitLabel.font = .italicSystemFont(ofSize: 10)
        editButton.tintColor = .systemGray4
        productImageView.tintColor = .red
        bottomView.layer.cornerRadius = bottomView.frame.height * 0.1
    }
    
    override func setBorder(width: CGFloat = 1.0, color: UIColor) {
        bottomView.setBorder(color: color)
    }
    
    func configure() {
        nameLabel.text = product.name
        
        quantityLabel.text = "Количество: " + product.qtyStr
        measureUnitLabel.text = "Единица измерения: \(product.measureUnit.full!) (\(product.measureUnit.short!))"
        if let image = product.image {
            productImageView.image = image
        }
        productImageView.tintColor = product.color
    }
    
}
