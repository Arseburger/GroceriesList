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
    
    private var color: UIColor = .clear
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomView.layer.cornerRadius = bottomView.frame.width * 0.1
    }
    
    func configure(with item: Product) {
        isExpiredSign.isHidden = item.expDate > Date.now
        
        color = item.expDate >= Date.now.advanced(by: threeDays)
        ? .darkGray
        : .red.withAlphaComponent(
            item.expDate <= Date.now
            ? 1.0
            : max(0.3, item.expDate.distance(to: Date.now).advanced(by: threeDays) / (threeDays))
        )
        
        bottomView.setShadow(color: color)
        
        if let image = item.image {
            imageView.image = image
        }
        nameLabel.text = item.name
        infoLabel.text = item.qtyStr + " \(item.measureUnit.short!)"
        imageView.tintColor = item.color
    }
    
    override var isHighlighted: Bool {
        didSet {
            bottomView.setBorder(width: isHighlighted ? 1.0 : 0.0, color: color.withAlphaComponent(0.5))
            layer.opacity = isHighlighted ? 0.8 : 1.0
        }
    }
 
    override func prepareForReuse() {
        super.prepareForReuse()
        isExpiredSign.isHidden = true
        imageView.tintColor = .clear
        nameLabel.text = ""
        infoLabel.text = ""
    }
    
}
