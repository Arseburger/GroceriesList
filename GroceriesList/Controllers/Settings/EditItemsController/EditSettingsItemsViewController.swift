//
//  EditSettingsItemsViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 29.06.2024.
//

import UIKit

final class EditSettingsItemsViewController: UIViewController {
    
    @IBOutlet private weak var viewCenterY: NSLayoutConstraint!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var mainTextField: UITextField!
    @IBOutlet private weak var secondaryTextField: UITextField!
    @IBOutlet private weak var mainView: UIView!
    
    @IBAction private func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func confirmButtonPressed(_ sender: Any) {
        if let full = mainTextField.text,
            let short = secondaryTextField.text {
            
            self.item = MeasureUnit(full: full, short: short)
            
            state == .edit
            ? didUpdateItem(item)
            : didAddItem(item)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    var item: MeasureUnit = ("", "")
    private var state: SettingsActions = .add
    
    var didUpdateItem: (MeasureUnit) -> Void = { _ in }
    var didAddItem: (MeasureUnit)-> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
        configure(with: self.item, state: self.state)
    }
    
    func set(item: MeasureUnit, state: SettingsActions) {
        self.item = item
        self.state = state
    }
    
    func configure(with unit: MeasureUnit = ("", ""), state: SettingsActions) {
        
        if state == .edit {
            mainTextField.text = unit.full
            secondaryTextField.text = unit.short
            
            confirmButton.setTitle("Изменить", for: .normal)
            confirmButton.isEnabled = true
        } else {
            confirmButton.setTitle("Добавить", for: .normal)
            confirmButton.isEnabled = false
        }
        
    }
}

private extension EditSettingsItemsViewController {
    
    func setupAppearence() {
        setupNotifications()
        setupTextFields()
        let radius = mainView.frame.height * 0.1
        mainView.layer.cornerRadius = radius
        view.backgroundColor = .clear
        
        cancelButton.layer.cornerRadius  = radius
        confirmButton.layer.cornerRadius = radius
        confirmButton.layer.maskedCorners = [.layerMaxXMaxYCorner]
        cancelButton.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        mainView.setBorder(color: .mainColor)
        
        cancelButton.setTitle("Закрыть", for: .normal)
        
        cancelButton.setTitleColor(.red, for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.setTitleColor(.systemGray4, for: .highlighted)
        
        cancelButton.backgroundColor = .white
        confirmButton.backgroundColor = .mainColor
        
    }
    
    func setupTextFields() {
        mainTextField.placeholder = "Полное название единицы измерения"
        mainTextField.textAlignment = .left
        mainTextField.textColor = .black
        mainTextField.font = .systemFont(ofSize: 13, weight: .regular)
        
        secondaryTextField.placeholder = "Сокращённое название единицы измерения"
        secondaryTextField.textAlignment = .left
        secondaryTextField.textColor = .darkGray
        secondaryTextField.font = .systemFont(ofSize: 13, weight: .regular)
        
        [mainTextField, secondaryTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
    }
    
    func setupNotifications() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelEditing))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillAppear(notification: NSNotification?) {
        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight: CGFloat
        keyboardHeight = keyboardFrame.cgRectValue.height - view.safeAreaInsets.bottom
        viewCenterY.constant = (view.safeAreaInsets.top - view.safeAreaInsets.bottom - keyboardHeight) * 0.5
        
        UIView.animate(withDuration: 0, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    @objc
    private func keyboardWillDisappear(notification: NSNotification?) {
        viewCenterY.constant = 0.0
        
        UIView.animate(withDuration: 0, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    @objc
    private func cancelEditing() {
        if mainTextField.isEditing || secondaryTextField.isEditing {
            view.endEditing(true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        let hasText = mainTextField.hasText && secondaryTextField.hasText
        confirmButton.isEnabled = hasText
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.setTitleColor(.darkGray, for: .disabled)
    }
    
    convenience init(item: MeasureUnit) {
        self.init()
        self.item = item
    }
}

enum SettingsActions {
    case edit
    case add
}
