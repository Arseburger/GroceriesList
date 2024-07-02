//
//  SettingsFooter.swift
//  GroceriesList
//
//  Created by Александр Королёв on 22.06.2024.
//

import UIKit

class SettingsFooter: UITableViewHeaderFooterView {
    
    static let identifier: String = "settingsHeader"
    var addNewItem: (EditSettingsItemsViewController, MeasureUnit) -> Void = { _, _ in }
    
    private lazy var label: UILabel = {
        $0.backgroundColor = .mainColor
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 13, weight: .bold)
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        $0.layer.cornerRadius = 20
        return $0
    }(UILabel())
    
    func setTitle(_ title: String) {
        label.text = title
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = true
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
        addTapGesture()
    }
    
    private func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addItem))
        contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func addItem() {
        let vc = EditSettingsItemsViewController()
        vc.set(item: ("", ""), state: .add)
        addNewItem(vc, vc.item)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
