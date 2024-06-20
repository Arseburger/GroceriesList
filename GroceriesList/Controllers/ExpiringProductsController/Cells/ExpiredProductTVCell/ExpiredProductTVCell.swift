//
//  ExpiredProductTVCell.swift
//  GroceriesList
//
//  Created by Александр Королёв on 10.06.2024.
//

import UIKit

class ExpiredProductTVCell: UITableViewCell {

    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var expDateLabel: UILabel!
    @IBOutlet private weak var bottomView: UIView!
    
    var item: Product = .defaultProduct {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomView.layer.cornerRadius = bottomView.frame.width * 0.05
        bottomView.backgroundColor = .systemGray6
        bottomView.setBorder(color: .systemGray3)
        productImageView.layer.cornerRadius = productImageView.frame.height * 0.125
    }

    func configure() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        
        productNameLabel.textColor = .darkGray
        productNameLabel.font = .systemFont(ofSize: 17.0, weight: .semibold)
        expDateLabel.font = .italicSystemFont(ofSize: 14.0)
        
        
        expDateLabel.text = "Срок годности: " + formatter.string(from: item.expDate)
        expDateLabel.textColor = item.expDate < Date.now
        ? .init(red: 1.0, green: 0.2, blue: 0.1, alpha: 0.7)
        : .darkText
        
        
        productImageView.image = item.image
        productNameLabel.text = item.name
        productImageView.tintColor = item.color
        
    }
    
}
