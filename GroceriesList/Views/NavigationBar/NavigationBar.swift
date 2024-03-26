//
//  NavigationBar.swift
//  GroceriesList
//
//  Created by Александр Королёв on 24.03.2024.
//

import UIKit

class NavigationBar: UINavigationBar {
    
    private enum Constants {
        static let height: CGFloat = 44
    }
    
    private lazy var leftButton: UIButton = {
        return $0
    }(UIButton())
    
    private lazy var rightButton: UIButton = {
        return $0
    }(UIButton())
    
    private lazy var titleLabel: UILabel = {
        return $0
    }(UILabel())
    
    func configure(title: String, buttons: [NavBarButtons]) {
        titleLabel.text = title
        leftButton.isHidden = !(buttons.contains(.left))
        rightButton.isHidden = !(buttons.contains(.right))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maxPosY = safeAreaInsets.top + Constants.height
        let minPosY = safeAreaInsets.top
        let midPosY = (maxPosY - minPosY) / 2.0
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

enum NavBarButtons {
    case left
    case right
}
