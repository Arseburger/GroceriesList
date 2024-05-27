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
    
    func goTo(_ vc: UIViewController, with text: String, shouldAddTopView: Bool = true) {
        let frame = vc.view.frame
        if shouldAddTopView {
            let topView: UIView = UIView(
                frame: .init(
                    origin: .zero,
                    size: .init(
                        width: frame.width,
                        height: navigationController?.navigationBar.frame.minY ?? 10
                    )
                )
            )
            topView.backgroundColor = .mainColor
            vc.view.addSubview(topView)
        }
        
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

extension String {
    
    static func makeAttrLabelText(prefix: String? = nil, _ main: String, postfix: String? = nil) -> NSAttributedString {
        
        let nsString = NSMutableAttributedString()
        
        if let prefix = prefix {
            nsString.append(
                NSAttributedString(
                    string: prefix,
                    attributes:
                        [
                            .font : UIFont.boldSystemFont(ofSize: 17),
                            .strokeColor : UIColor.black
                        ]
                )
            )
        }
        
        nsString.append(
            NSAttributedString(
                string: main,
                attributes:
                    [
                        .font : UIFont.systemFont(ofSize: 17),
                        .strokeColor : UIColor.black
                    ]
            )
        )
        
        if let postfix = postfix {
            nsString.append(
                NSAttributedString(
                    string: postfix,
                    attributes:
                        [
                            .font : UIFont.italicSystemFont(ofSize: 17.0),
                            .strokeColor : UIColor.black
                        ]
                )
            )
        }
        return nsString
    }
    
}
