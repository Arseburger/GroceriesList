//
//  EditContainerProdsTVCell.swift
//  GroceriesList
//
//  Created by Александр Королёв on 27.05.2024.
//

import UIKit

class EditContainerProdsTVCell: UITableViewCell {

    static let identifier: String = String.init(describing: EditContainerProdsTVCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    
}
