//
//  AddNewItemCollectionViewCell.swift
//  GroceriesList
//
//  Created by Александр Королёв on 24.05.2024.
//

import UIKit

class AddNewItemCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = String.init(describing: self)
    
    var didPressAddButton: (() -> [Product])?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
