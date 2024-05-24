//
//  DetailItemCollectionViewCell.swift
//  GroceriesList
//
//  Created by Александр Королёв on 24.05.2024.
//

import UIKit

class DetailItemCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    static var identifier: String = String.init(describing: self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with item: Product) {
        if let image = item.image {
            imageView.image = image
        }
        nameLabel.text = item.name
        infoLabel.text = "\(item.quantity)"
    }
    
}
