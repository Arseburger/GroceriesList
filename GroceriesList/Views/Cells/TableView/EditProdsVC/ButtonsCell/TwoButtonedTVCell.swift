//
//  TwoButtonedTVCell.swift
//  GroceriesList
//
//  Created by Александр Королёв on 27.05.2024.
//

import UIKit

class TwoButtonedTVCell: UITableViewCell {
    
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    
    @IBAction private func addButtonPressed(_ sender: Any) {
        addNewProduct()
        print("add")
    }
    
    @IBAction private func deleteButtonPressed(_ sender: Any) {
        print("delete")
    }
    
    var addNewProduct: () -> Void = {  }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearence()
        selectionStyle = .none
    }
    
    override var editingStyle: UITableViewCell.EditingStyle {
        .none
    }
    
    override var editingInteractionConfiguration: UIEditingInteractionConfiguration {
        .none
    }
    
    private func setupAppearence() {
        [addButton, deleteButton].forEach { button in
            guard let button = button else { return }
            button.backgroundColor = .systemGray6
            button.layer.cornerRadius = button.frame.height * 0.125
            button.setBorder(width: 0.5, color: .gray)
        }
        
        addButton.setTitle("Добавить", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.setTitleColor(.black.withAlphaComponent(0.3), for: .highlighted)
        
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.setTitleColor(.red.withAlphaComponent(0.3), for: .highlighted)
    }
    
    func addItem(_ closure: @escaping () -> Void) {
        addNewProduct = closure
    }
    
}
