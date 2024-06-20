//
//  NewProductViewController.swift
//  GroceriesList
//
//  Created by Александр Королёв on 07.06.2024.
//

import UIKit
import Photos

final class NewProductViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: @IBOutlets -
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var quantityTextField: UITextField!
    @IBOutlet private weak var expDatePicker: UIDatePicker!
    @IBOutlet private weak var measureUnitPicker: UIPickerView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var expDateLabel: UILabel!
    @IBOutlet private weak var measureUnitLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    
    // MARK: @IBActions -
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let newProduct: Product = .init(
            name: nameTextField.text ?? "",
            expDate: expDatePicker.date,
            quantity: Double(quantityTextField.text ?? "") ?? 0.0,
            image: imageView.image,
            measureUnit: measureUnits.units[measureUnitPicker.selectedRow(inComponent: 0)],
            containerId: containerId
        )
        
        if !nameTextField.hasText || !quantityTextField.hasText {
            let alert = UIAlertController(
                title: "Ошибка",
                message: "Невозможно добавить продукт, так как заполнены не все поля",
                preferredStyle: .alert
            )
            
            alert.addAction(
                .init(
                    title: "OK",
                    style: .default) { [weak self] _ in
                        self?.dismiss(animated: true, completion: nil)
                    }
            )
            present(alert, animated: true)
            
        }
        
        addNewProduct(newProduct)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Properties -
    
    var addNewProduct: (Product) -> Void = { _ in }
    var containerId: UInt8? = 0
    let measureUnits = MeasureUnitStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = true
        measureUnitPicker.delegate = self
        measureUnitPicker.dataSource = self
        setupAppearence()
    }
    
    // MARK: Lifecycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Новый продукт"
    }
    
}

// MARK: UI Setup -

private extension NewProductViewController {
    
    func setupAppearence() {
        
        let dismissKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        let imageViewGestureRcognizer = UITapGestureRecognizer(target: self, action: #selector(openGallery))
        
        scrollView.showsVerticalScrollIndicator = false
        
        imageView.isUserInteractionEnabled = true
        imageView.image = .init(named: "chooseProductImage")
        imageView.addGestureRecognizer(imageViewGestureRcognizer)
        
        addButton.backgroundColor = .mainColor
        addButton.setTitle("Добавить", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = addButton.frame.height * 0.1
        
        expDateLabel.text = "Срок годности"
        measureUnitLabel.text = "Единица измерения"
        
        
        expDatePicker.datePickerMode = .date
        expDatePicker.contentHorizontalAlignment = .fill
        measureUnitPicker.contentMode = .center
        
        [expDatePicker, measureUnitPicker].forEach {
            $0?.setBorder(color: .mainColor)
            $0?.layer.cornerRadius = ($0?.frame.width)! * 0.1
        }
        
        view.addGestureRecognizer(dismissKeyboardGestureRecognizer)
        
        setupTextFields()
        
    }
    
    func setupTextFields() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        quantityTextField.keyboardType = .decimalPad
        nameTextField.placeholder = "Введите название продукта"
        quantityTextField.placeholder = "Введите количество"
    }
    
    @objc private func keyboardWillAppear(notification: NSNotification?) {
        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight: CGFloat
        keyboardHeight = keyboardFrame.cgRectValue.height - view.safeAreaInsets.bottom
        scrollView.contentInset = .init(top: 0, left: 0, bottom: keyboardHeight + 8, right: 0)
        
        UIView.animate(withDuration: 0) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        imageView.gestureRecognizers?.forEach {
            $0.isEnabled = false
        }
    }
    
    @objc private func keyboardWillDisappear(notification: NSNotification?) {
        scrollView.contentInset = .zero
        
        UIView.animate(withDuration: 0) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        imageView.gestureRecognizers?.forEach {
            $0.isEnabled = true
        }
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
}

// MARK: PickerView Delegate -

extension NewProductViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        measureUnits.units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        measureUnitPicker.frame.width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        32
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return measureUnits.units[row].full! + " (" + measureUnits.units[row].short! + ")"
    }
    
}

// MARK: ImagePicker Delegate -

extension NewProductViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        dismiss(animated: true, completion: { [weak self] in
            self?.imageView.image = image
        })
    }
}

