//
//  ProductViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 25.05.2024.
//

import UIKit

final class ProductViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameTextView: UITextView!
    @IBOutlet private weak var quantityTextView: UITextView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var expdatelabel: UILabel!
    @IBOutlet private weak var saveChangesButton: UIButton!
    @IBOutlet private weak var measureUnitPicker: UIPickerView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var datePickerHeightConstraint: NSLayoutConstraint!
    
    @IBAction private func saveButtonPressed(_ sender: Any) {
        product = getUpdatedProduct()
        toggleEditingMode()
    }
    
    private var inEditMode = false
    private var MUStorage = MeasureUnitStorage.shared
    
    var product: Product = .randomProduct()
    var didUpdateProduct: (Product) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = .init(image: .init(systemName: "pencil"), style: .plain, target: self, action: #selector(toggleEditingMode))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        didUpdateProduct(product)
    }
    
    func getUpdatedProduct() -> Product {
        guard nameTextView.hasText && quantityTextView.hasText else { return product }
        var newProduct = product
        newProduct.name = nameTextView.text
        newProduct.quantity = Double(quantityTextView.text) ?? 0.0
        newProduct.expDate = datePicker.date
        newProduct.measureUnit = MUStorage.units[measureUnitPicker.selectedRow(inComponent: 0)]
        return newProduct
    }
    
    func setupAppearence() {
        
        [nameTextView, quantityTextView].forEach {
            $0?.delegate = self
            $0?.isScrollEnabled = false
            $0?.isEditable = false
            $0?.layer.cornerRadius = 8
        }
        
        quantityTextView.keyboardType = .decimalPad
        
        saveChangesButton.setTitle("Сохранить", for: .normal)
        saveChangesButton.setTitleColor(.white, for: .normal)
        saveChangesButton.setTitleColor(.systemGray5, for: .highlighted)
        saveChangesButton.backgroundColor = .mainColor
        saveChangesButton.isHidden = true
        saveChangesButton.layer.cornerRadius = 8
        
        measureUnitPicker.isHidden = true
        measureUnitPicker.delegate = self
        measureUnitPicker.dataSource = self
        measureUnitPicker.layer.cornerRadius = 8
        
        datePicker.layer.cornerRadius = 8
        datePicker.setDate(product.expDate, animated: true)
        datePicker.isUserInteractionEnabled = false
        
        imageView.contentMode = .scaleAspectFill
        
        setupNotifications()
    }
    
    private func configure() {
        if let image = product.image {
            imageView.image = image
        }
        imageView.tintColor = product.color
        nameTextView.text = product.name
        
        quantityTextView.attributedText = String.makeAttrLabelText("", postfix: product.qtyStr + " \(product.measureUnit.full!)")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        
    }

    func setProduct(product: Product?) {
        if let prod = product {
            self.product = prod
        }
    }
    
    @objc
    private func toggleEditingMode() {
        inEditMode.toggle()
        
        if inEditMode {
            quantityTextView.text = product.qtyStr
            measureUnitPicker.selectRow(MUStorage.getIdOf(product.measureUnit) ?? 0, inComponent: 0, animated: true)
        } else {
            quantityTextView.attributedText = String.makeAttrLabelText("", postfix: product.qtyStr + " \(product.measureUnit.full!)")
            datePicker.setDate(product.expDate, animated: true)
        }
        
        datePicker.isUserInteractionEnabled = inEditMode ? true : false
        datePicker.setBorder(color: inEditMode ? .mainColor : .clear)
        datePickerHeightConstraint.constant = inEditMode ? 150 : 60
        
        saveChangesButton.isHidden = !inEditMode
        measureUnitPicker.isHidden = !inEditMode
        
        measureUnitPicker.setBorder(color: inEditMode ? .mainColor : .clear)
        
        [nameTextView, quantityTextView].forEach {
            $0?.isEditable = inEditMode
            $0?.setBorder(color: inEditMode ? .mainColor : .clear)
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
    }
    
}

extension ProductViewController: UITextViewDelegate {
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
        let keyboardHeight = keyboardFrame.cgRectValue.height - view.safeAreaInsets.bottom
        
        bottomConstraint.constant = keyboardHeight + 8
        
        UIView.animate(withDuration: 0, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    @objc
    private func keyboardWillDisappear(notification: NSNotification?) {
        
        bottomConstraint.constant = 8
        
        UIView.animate(withDuration: 0, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    
    @objc
    private func cancelEditing() {
        view.endEditing(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.hasText {
            textView.text = product.name
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.setBorder(color: textView.hasText ? .mainColor : .red)
    }
}

extension ProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        MUStorage.units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return MUStorage.units[row].full! + " (" + MUStorage.units[row].short! + ")"
    }
    
}
