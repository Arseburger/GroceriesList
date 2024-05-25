//
//  AddNewItemCollectionViewCell.swift
//  GroceriesList
//
//  Created by Александр Королёв on 24.05.2024.
//

import UIKit

class AddNewItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var bottomView: UIView!
    
    var didPressAddButton: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bottomView.layer.cornerRadius = bottomView.frame.width * 0.1
    }

}
