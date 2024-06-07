//
//  DetailItemCollectionViewCell.swift
//  GroceriesList
//
//  Created by Александр Королёв on 24.05.2024.
//

import UIKit

class DetailItemCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    
    @IBOutlet private weak var isExpiredSign: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomView.layer.cornerRadius = bottomView.frame.width * 0.1
        
    }
    
    func configure(with item: Product) {
        isExpiredSign.isHidden = (item.expDate?.distance(to: Date.now))! < 0

        if let image = item.image {
            imageView.image = image
        }
        nameLabel.text = item.name
        infoLabel.text = "\(item.quantity) \(item.measureUnit.short!)"
    }
    
    override var isHighlighted: Bool {
        didSet {
            bottomView.setBorder(width: isHighlighted ? 1.0 : 0.0, color: .mainColor)
            layer.opacity = isHighlighted ? 0.8 : 1.0
        }
    }
    
}
