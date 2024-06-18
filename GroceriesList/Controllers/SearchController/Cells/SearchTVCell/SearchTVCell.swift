//
//  SearchTVCell.swift
//  GroceriesList
//
//  Created by Александр Королёв on 15.06.2024.
//

import UIKit

class SearchTVCell: UITableViewCell {

    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.numberOfLines = 0
        infoLabel.numberOfLines = 0
    }
    
    func configure(with item: Product) {
        nameLabel.text = item.name
        infoLabel.text = "\(item.id)"
    }
    
    func animate(duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0.3, options: []) {
            self.bottomView.backgroundColor = .mainColor
        } completion: { _ in
            UIView.animate(withDuration: duration) {
                self.bottomView.backgroundColor = .clear
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        infoLabel.text = ""
    }
    
}
