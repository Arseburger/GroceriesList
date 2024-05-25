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
            image: UIImage(systemName: "searchIcon"),
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
    
    func goTo(_ vc: UIViewController, with text: String) {
        let frame = vc.view.frame
        let width: CGFloat = 200, height: CGFloat = 40
        vc.view.backgroundColor = .white
        let label: UILabel = UILabel(
            frame: .init(
                origin: .init(
                    x: frame.midX - width / 2.0,
                    y: frame.midY - height / 2.0
                ),
                size: .init(
                    width: width,
                    height: height
                )
            )
        )
        label.textColor = .black
        label.textAlignment = .center
        label.text = text
        vc.view.addSubview(label)
        vc.view.layoutSubviews()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension UINavigationController {
    func setupNavigationBar() {
        navigationBar.backIndicatorImage = UIImage(systemName: "backArrowIcon")
        navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "backArrowIcon")
    }
}
