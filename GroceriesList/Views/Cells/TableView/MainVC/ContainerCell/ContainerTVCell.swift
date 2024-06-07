//
//  ContainerTVCell.swift
//  GroceriesList
//
//  Created by Александр Королёв on 24.03.2024.
//

import UIKit

final class ContainerTVCell: UITableViewCell {
    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        arrowImage.layer.cornerRadius = arrowImage.frame.height * 0.5
        arrowImage.tintColor = UIColor.mainColor
        arrowImage.window?.layer.cornerRadius = 20
        layer.cornerRadius = frame.height * 0.25
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        bottomView.setBorder(width: highlighted ? 1 : 0, color: .mainColor)
        layer.opacity = highlighted ? 0.6 : 1.0
    }
    
    func configure(with item: Storage) {
        topLabel.text = item.name
        if let image = item.image {
            imageLogo.image = image
        }
        
        bottomLabel.text = item.expiredProducts.isEmpty
            ? "Нет продуктов с истекающим сроком годности"
            : "Продуктов с истекающим сроком годности: \(item.expiredProducts.count)"
        
        bottomLabel.textColor = item.expiredProducts.isEmpty
            ? .black
            : .red
        
    }
    
}
