//
//  SettingsHeader.swift
//  GroceriesList
//
//  Created by Александр Королёв on 22.06.2024.
//

import UIKit

class SettingsHeader: UITableViewHeaderFooterView {
    
    static let identifier: String = "settingsHeader"
    
    private lazy var label: UILabel = {
        $0.backgroundColor = .mainColor
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 13, weight: .bold)
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        $0.layer.cornerRadius = 14
        return $0
    }(UILabel())
    
    func setTitle(_ title: String) {
        label.text = title
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        var configuration: UIBackgroundConfiguration = .clear()
        configuration.backgroundColor = .mainColor
        configuration.cornerRadius = 8
        backgroundConfiguration = configuration
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
