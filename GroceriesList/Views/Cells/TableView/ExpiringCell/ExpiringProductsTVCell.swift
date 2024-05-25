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
    
    var expiredProductsCounter: Int = 0
    
    func getRotts(_ number: Int) {
        productsCountLabel.text = "\(number)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productsCountLabel.textColor = .black
        productsCountLabel.layer.cornerRadius = productsCountLabel.frame.height * 0.5
        productsCountLabel.layer.borderColor = UIColor.red.cgColor
        productsCountLabel.layer.borderWidth = 1.0
        productsCountLabel.layer.backgroundColor = UIColor.white.cgColor
        infoLabel.textColor = .red
        infoLabel.text = "Продукты, которые испортятся в течение 3-х дней!"
        selectionStyle = .none
    }
    
}
