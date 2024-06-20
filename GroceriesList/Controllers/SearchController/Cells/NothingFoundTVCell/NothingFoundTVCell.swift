//
//  NothingFoundTVCell.swift
//  GroceriesList
//
//  Created by Александр Королёв on 18.06.2024.
//

import UIKit

class NothingFoundTVCell: UITableViewCell {

    @IBOutlet private weak var searchResultLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with item: String) {
        searchResultLabel.text = item.isEmpty ? "Введён пустой запрос" : "По запросу '" + item + "' ничего не найдено"
    }
    
}
