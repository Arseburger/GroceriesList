//
//  Extensions.swift
//  GroceriesList
//
//  Created by Александр Королёв on 24.03.2024.
//

import UIKit

extension UIColor {
    static let mainColor = UIColor(red: 137.0 / 255.0, green: 194.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
}

extension Bool {
    static func +=(lhs: inout Bool, rhs: Bool) {
        lhs = lhs || rhs
    }
    
    static func *=(lhs: inout Bool, rhs: Bool) {
        lhs = lhs && rhs
    }
}

extension UIViewController {
    func addNavigationBarAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "searchIcon"),
            style: .plain,
            target: self,
            action: #selector(addButtonPressed)
        )
    }
    
    @objc
    private func addButtonPressed() {
        let vc = UIViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension UINavigationController {
    func setupNavigationBar() {
        navigationBar.backIndicatorImage = UIImage(named: "backArrowIcon")
        navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backArrowIcon")
    }
}
