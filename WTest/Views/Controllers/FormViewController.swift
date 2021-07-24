//
//  FormViewController.swift
//  WTest
//
//  Created by Leonardo Bilia on 22/07/21.
//

import UIKit

class FormViewController: UIViewController {
    
    private lazy var scrollView = UIScrollView()
    private lazy var freeTextField = TextFieldView()
    private lazy var emailTextField = TextFieldView()
    private lazy var numbersTextField = TextFieldView()
    private lazy var uppercasedAndHyphensTextField = TextFieldView()
    private lazy var selectionTextField = TextFieldView()
    private lazy var dateTextField = TextFieldView()
    private lazy var zipCodeTextField = TextFieldView()
    
    private lazy var validateButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Form.buttonTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 27
        button.layer.masksToBounds = true
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(validateButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let datePicker = UIDatePicker()
    private let selectionPicker = UIPickerView()
    
    private var viewModel = FormViewModel()
    
    var selectedZipCode: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionPicker.delegate = self
        
        setupScrollView()
        setupTextFields()
        setupDatePickerToolbar()
        setupPickerToolbar()
        setupDatePicker()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        zipCodeTextField.text = selectedZipCode
        zipCodeTextField.validated = zipCodeTextField.text != nil
        validateFields()
    }
    
    // MARK: - Methods
    
    private func setupTextFields() {
        freeTextField.translatesAutoresizingMaskIntoConstraints = false
        freeTextField.placeholder = Constants.Form.freeFieldPlaceholder
        freeTextField.style = .regular
        freeTextField.completion = { [weak self] in
            self?.validateFields()
        }
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = Constants.Form.emailFieldPlaceholder
        emailTextField.validationType = .email
        emailTextField.style = .regular
        emailTextField.keyboardType = .emailAddress
        emailTextField.completion = { [weak self] in
            self?.validateFields()
        }
        
        numbersTextField.translatesAutoresizingMaskIntoConstraints = false
        numbersTextField.placeholder = Constants.Form.numbersFieldPlaceholder
        numbersTextField.style = .regular
        numbersTextField.keyboardType = .numberPad
        numbersTextField.completion = { [weak self] in
            self?.validateFields()
        }
        
        uppercasedAndHyphensTextField.translatesAutoresizingMaskIntoConstraints = false
        uppercasedAndHyphensTextField.placeholder = Constants.Form.uppercasedAndHyphensFieldPlaceholder
        uppercasedAndHyphensTextField.autocapitalization = .allCharacters
        uppercasedAndHyphensTextField.style = .regular
        uppercasedAndHyphensTextField.completion = { [weak self] in
            self?.validateFields()
        }
        
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.placeholder = Constants.Form.dateFieldPlaceholder
        dateTextField.style = .picker
        dateTextField.input = datePicker
        
        selectionTextField.translatesAutoresizingMaskIntoConstraints = false
        selectionTextField.placeholder = Constants.Form.selectionFieldPlaceholder
        selectionTextField.style = .picker
        selectionTextField.input = selectionPicker
        
        zipCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        zipCodeTextField.placeholder = Constants.Form.zipCodeFieldPlaceholder
        zipCodeTextField.style = .presenter
        zipCodeTextField.completion = { [weak self] in
            let controller =  ZipCodeTableViewController()
            controller.modal = true
            controller.delegate = self
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            self?.present(navigationController, animated: true, completion: nil)
        }
    }
    
    private func validateFields() {
        if freeTextField.validated, emailTextField.validated, numbersTextField.validated, uppercasedAndHyphensTextField.validated, dateTextField.validated, selectionTextField.validated, zipCodeTextField.validated {
            validateButton.isEnabled = true
            validateButton.backgroundColor = .systemTeal
        } else {
            validateButton.isEnabled = false
            validateButton.backgroundColor = .lightGray
        }
    }
    
    private func setupDatePickerToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(pickerCancelAction)), UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(datePickerDoneAction))], animated: true)
        dateTextField.accessoryView = toolbar
    }
    
    private func setupPickerToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.setItems([ UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(pickerCancelAction)), UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDoneAction))
        ], animated: true)
        selectionTextField.accessoryView = toolbar
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    // MARK: - Actions
    
    @objc private func validateButtonAction() {
        let alert = UIAlertController(title: Constants.Alert.Title.awesome, message: Constants.Alert.Message.formValidated, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Alert.Action.ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func pickerCancelAction() {
        view.endEditing(true)
    }
    
    @objc func pickerDoneAction() {
        view.endEditing(true)
        validateFields()
    }
    
    @objc func datePickerDoneAction() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "PT")
        formatter.dateStyle = .full
        let dateString = formatter.string(from: datePicker.date)
        
        let calender: Calendar = Calendar(identifier: .gregorian)
        let weekday = calender.component(.weekday, from: datePicker.date)
        
        dateTextField.text = dateString
        dateTextField.textColor = weekday == 2 ? .red : .black
        dateTextField.validated = dateTextField.text != nil && dateTextField.textColor == .black
        
        view.endEditing(true)
        validateFields()
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension FormViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numberOfComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRowsInComponent(component)
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.titleForRow(row)
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.didSelectRow(row) { [weak self] content in
            self?.selectionTextField.text = content
            self?.selectionTextField.validated = self?.selectionTextField.text != nil
        }
    }
}

// MARK: - UI

extension FormViewController {
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        scrollView.addSubview(freeTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(numbersTextField)
        scrollView.addSubview(uppercasedAndHyphensTextField)
        scrollView.addSubview(dateTextField)
        scrollView.addSubview(selectionTextField)
        scrollView.addSubview(zipCodeTextField)
        scrollView.addSubview(validateButton)
        
        NSLayoutConstraint.activate([
            freeTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            freeTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            freeTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            
            emailTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            emailTextField.topAnchor.constraint(equalTo: freeTextField.bottomAnchor, constant: 8),
            
            numbersTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            numbersTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            numbersTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            
            uppercasedAndHyphensTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            uppercasedAndHyphensTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            uppercasedAndHyphensTextField.topAnchor.constraint(equalTo: numbersTextField.bottomAnchor, constant: 8),
            
            dateTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            dateTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            dateTextField.topAnchor.constraint(equalTo: uppercasedAndHyphensTextField.bottomAnchor, constant: 8),
            
            selectionTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            selectionTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            selectionTextField.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 8),
            
            zipCodeTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            zipCodeTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            zipCodeTextField.topAnchor.constraint(equalTo: selectionTextField.bottomAnchor, constant: 8),
            
            validateButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            validateButton.widthAnchor.constraint(equalToConstant: 255),
            validateButton.heightAnchor.constraint(equalToConstant: 54),
            validateButton.topAnchor.constraint(equalTo: zipCodeTextField.bottomAnchor, constant: 48),
            validateButton.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor, constant: -300)
        ])
    }
}
