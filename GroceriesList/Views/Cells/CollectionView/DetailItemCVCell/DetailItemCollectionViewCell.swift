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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomView.layer.cornerRadius = bottomView.frame.width * 0.1
        
    }
    
    func configure(with item: Product) {
        if let image = item.image {
            imageView.image = image
        }
        nameLabel.text = item.name
        infoLabel.text = "\(Int(item.quantity)) \(item.measureUnit.short!)"
    }
    
}
