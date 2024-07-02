//
//  SettingsMUTVCell.swift
//  GroceriesList
//
//  Created by Александр Королёв on 21.06.2024.
//

import UIKit

class SettingsMUTVCell: UITableViewCell {

    @IBOutlet private weak var fullTitleLabel: UILabel!
    @IBOutlet private weak var shortTitleLabel: UILabel!
    @IBOutlet private weak var bottomBorder: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomBorder.backgroundColor = .mainColor
    }
    
    func configure(with item: MeasureUnit) {
        fullTitleLabel.text = item.full
        shortTitleLabel.text = item.short
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
