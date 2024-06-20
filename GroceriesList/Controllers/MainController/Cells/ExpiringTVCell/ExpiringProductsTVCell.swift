//
//  ExpiringProductsTVCell.swift
//  GroceriesList
//
//  Created by Александр Королёв on 26.03.2024.
//

import UIKit

final class ExpiringProductsTVCell: UITableViewCell {

    @IBOutlet private weak var rightArrow: UIImageView!
    @IBOutlet private weak var productsCountLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var bottomView: UIView!
    
    var expiredProductsCounter: Int = 0
    
    func getRotts(_ number: Int) {
        productsCountLabel.text = "\(number)"
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        bottomView.setBorder(width: highlighted ? 1.0 : 0.0, color: .red.withAlphaComponent(0.6))
        layer.opacity = highlighted ? 0.7 : 1.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productsCountLabel.textColor = .black
        productsCountLabel.layer.cornerRadius = productsCountLabel.frame.height * 0.5
        productsCountLabel.setBorder(width: 1.0, color: .red)
        productsCountLabel.layer.backgroundColor = UIColor.white.cgColor
        infoLabel.textColor = .red
        infoLabel.text = "Продукты, которые испортятся в течение 3-х дней!"
        selectionStyle = .none
    }
    
}
