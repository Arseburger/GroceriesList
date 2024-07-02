//
//  Extensions.swift
//  GroceriesList
//
//  Created by Александр Королёв on 24.03.2024.
//

import UIKit

extension UIColor {
    static let mainColor = UIColor(red: 137.0 / 255.0, green: 194.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    
    static let mainOpaqueColor = UIColor(red: 137.0 / 255.0, green: 194.0 / 255.0, blue: 235.0 / 255.0, alpha: 0.4)
    
    static func randomColor() -> UIColor {
        let rgb: (r: CGFloat, g: CGFloat, b: CGFloat) = (
            CGFloat.random(in: 0...255) / 255.0,
            CGFloat.random(in: 0...255) / 255.0,
            CGFloat.random(in: 0...255) / 255.0
        )
        let color = UIColor(red: rgb.r, green: rgb.g, blue: rgb.b, alpha: 1.0)
        return color
    }
    
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
        vc.navigationItem.title = text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getSwipeToDeleteAction(_ completion: @escaping UIContextualAction.Handler) -> UISwipeActionsConfiguration {
        .init(
            actions: [
                .init(
                    style: .destructive,
                    title: "Удалить",
                    handler: completion
                )
            ]
        )
    }
    
}

extension UINavigationController {
    func setupNavigationBar() {
        let appearence = UINavigationBarAppearance()
        appearence.titleTextAttributes = [.foregroundColor : UIColor.white]
        appearence.backgroundColor = .mainColor
        self.navigationBar.standardAppearance = appearence
        self.navigationBar.compactAppearance = appearence
        self.navigationBar.scrollEdgeAppearance = appearence
        self.navigationBar.backgroundColor = .mainColor
        self.navigationBar.tintColor = .white
        self.navigationItem.backButtonTitle = "Назад"
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

extension UIView {
    func setBorder(width: CGFloat = 1.0, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func setShadow(color: UIColor) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 1.0
        layer.shadowOffset = .init(width: 2.0, height: 2.0)
        layer.shadowOpacity = 0.5
    }
}

extension Date {
    static func shortDate(day: Int, month: Int, year: Int) -> Date {
        DateComponents.init(calendar: .init(identifier: .gregorian), timeZone: .init(abbreviation: "MSK"), year: year, month: month, day: day).date ?? Date.now
    }
}

extension UITableView {
    func register(_ cell: TableView.Cells) {
        register(cell.nib, forCellReuseIdentifier: cell.identifier)
    }
}
