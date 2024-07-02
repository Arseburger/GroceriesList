//
//  ExpiringProductsTVCell.swift
//  GroceriesList
//
//  Created by Александр Королёв on 26.03.2024.
//

import UIKit

final class ExpiringProductsTVCell: UITableViewCell {

    @IBOutlet private weak var rightArrow: UIImageView!
    @IBOutlet private weak var productsCountLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var bottomView: UIView!
    
    func getRotts(_ number: Int) {
        productsCountLabel.text = "\(number)"
        configure(rawState: number)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        bottomView.setBorder(width: highlighted ? 1.0 : 0.0, color: .red.withAlphaComponent(0.6))
        layer.opacity = highlighted ? 0.7 : 1.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productsCountLabel.textColor = .black
        productsCountLabel.layer.cornerRadius = productsCountLabel.frame.height * 0.5
        productsCountLabel.setBorder(width: 1.0, color: .red)
        productsCountLabel.layer.backgroundColor = UIColor.white.cgColor
        selectionStyle = .none
    }
    
    private func configure(rawState: Int) {
        let state = CellStates(rawValue: rawState < 1 ? rawState : 1)
        rightArrow.isHidden = rawState < 0
        productsCountLabel.isHidden = rawState < 0
        infoLabel.font = .systemFont(ofSize: 13, weight: rawState < 0 ? .bold : .regular)
        switch state {
            case .noExpProds:
                infoLabel.text = "Нет продуктов с истекающим сроком годности!"
                infoLabel.textColor = .black
            case .hasExpProds:
                infoLabel.text = "Продукты, которые испортятся в течение 3-х дней!"
                infoLabel.textColor = .red
            case .noContainers:
                infoLabel.textColor = .black
                
                infoLabel.text = "Нажмите на кнопку внизу, чтобы добавить хранилище!"
            case .none:
                break
        }
    }
    
}

enum CellStates: Int {
    case noContainers = -1
    case noExpProds = 0
    case hasExpProds = 1
}
