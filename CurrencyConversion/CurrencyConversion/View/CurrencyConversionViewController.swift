//
//  CurrencyConversionViewController.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 07/08/2024.
//

import UIKit
import os
import Combine

class CurrencyConversionViewController: UIViewController {

    // MARK: - UI Elements

    private lazy var pageTitle: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.isUserInteractionEnabled = false
        element.textAlignment = .left
        element.font = .monospacedSystemFont(ofSize: 30, weight: .bold)
        element.tintColor = .appColor(.accentColor)
        element.text = String(localized: "Currency Conversion")
        return element
    }()

    private lazy var separator: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.isUserInteractionEnabled = false
        element.backgroundColor = .black
        return element
    }()

    private lazy var fromLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.isUserInteractionEnabled = false
        element.textAlignment = .left
        element.font = .preferredFont(forTextStyle: .callout)
        element.tintColor = .appColor(.accentColor)
        element.text = String(localized: "From:")
        return element
    }()

    private lazy var fromButton: UIButton = {
        let element = UIButton(configuration: .plain())
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()

    private lazy var toLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.isUserInteractionEnabled = false
        element.textAlignment = .left
        element.font = .preferredFont(forTextStyle: .callout)
        element.tintColor = .appColor(.accentColor)
        element.text = String(localized: "To:")
        return element
    }()

    private lazy var toButton: UIButton = {
        let element = UIButton(configuration: .plain())
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()

    private lazy var amountLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.isUserInteractionEnabled = false
        element.textAlignment = .left
        element.font = .preferredFont(forTextStyle: .callout)
        element.tintColor = .appColor(.accentColor)
        element.text = String(localized: "Amount:")
        return element
    }()

    private lazy var amountTextField: UITextField = {
        let element = UITextField()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.placeholder = String(localized: "Amount to be converted")
        element.keyboardType = .decimalPad
        element.borderStyle = .roundedRect
        element.delegate = self
        return element
    }()

    private lazy var totalTitleLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.isUserInteractionEnabled = false
        element.textAlignment = .left
        element.font = .preferredFont(forTextStyle: .title2)
        element.tintColor = .appColor(.accentColor)
        element.text = String(localized: "Total:")
        return element
    }()

    private lazy var totalLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.isUserInteractionEnabled = false
        element.textAlignment = .left
        element.font = .preferredFont(forTextStyle: .body)
        element.tintColor = .appColor(.accentColor)
        element.text = String(localized: "Result")
        return element
    }()

    // MARK: - Private Variables

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: CurrencyConversionViewController.self)
    )

    private var fromValue: String = ""
    private lazy var actionClosureFrom = { [weak self] (action: UIAction) in
        guard let self else { return }
        self.fromValue = action.title
        self.logger.info("🏧 From value: \(self.fromValue)")
    }

    private var toValue: String = ""
    private lazy var actionClosureTo = { [weak self] (action: UIAction) in
        guard let self else { return }
        self.toValue = action.title
        self.logger.info("🏧 To value: \(self.toValue)")
    }

    private var amountValue: String = ""

    private var cancellables = Set<AnyCancellable>()

    private let viewModel: CurrencyConversionViewModelProtocol
    private var currencyList = [String: String]()

    // MARK: - Init

    init(viewModel: CurrencyConversionViewModelProtocol = CurrencyConversionViewModel()) {

        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewWillAppear(_ animated: Bool) {

        viewModel.fetchCurrencyList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGestureRecognizer()

        setupSubviews()
        setupConstraints()

        setupObservers()

        view.backgroundColor = .appColor(.backgroundColor)
    }

    // MARK: - Private Methods

    private func setupSubviews() {

        view.backgroundColor = .appColor(.backgroundColor)

        view.addSubview(pageTitle)
        view.addSubview(separator)
        
        view.addSubview(fromLabel)
        view.addSubview(fromButton)

        view.addSubview(toLabel)
        view.addSubview(toButton)

        view.addSubview(amountLabel)
        view.addSubview(amountTextField)

        view.addSubview(totalTitleLabel)
        view.addSubview(totalLabel)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            pageTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            pageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),

            separator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            separator.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 15),
            separator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            separator.heightAnchor.constraint(equalToConstant: 1),

            fromLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            fromLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 30),
            fromButton.leadingAnchor.constraint(equalTo: fromLabel.trailingAnchor, constant: 40),
            fromButton.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor),

            toLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            toLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor, constant: 30),
            toButton.leadingAnchor.constraint(equalTo: fromButton.leadingAnchor),
            toButton.centerYAnchor.constraint(equalTo: toLabel.centerYAnchor),

            amountLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            amountLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: 30),
            amountTextField.leadingAnchor.constraint(equalTo: fromButton.leadingAnchor, constant: 10),
            amountTextField.centerYAnchor.constraint(equalTo: amountLabel.centerYAnchor),

            totalTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            totalTitleLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 30),

            totalLabel.leadingAnchor.constraint(equalTo: fromButton.leadingAnchor, constant: 10),
            totalLabel.centerYAnchor.constraint(equalTo: totalTitleLabel.centerYAnchor),
        ])
    }

    private func setupObservers() {

        viewModel.currencyListDataPublisher.sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.logger.error("\(error)")
            case .finished:
                self?.logger.info("💶 Available currency list info received correctly from ViewModel")
            }
        } receiveValue: { [weak self] currencyList in
            guard let self else { return }
            self.currencyList = currencyList

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.configureDropdown(button: &self.fromButton, handler: self.actionClosureFrom)
                self.configureDropdown(button: &self.toButton, handler: self.actionClosureTo)
            }

        }
        .store(in: &cancellables)

    }

    private func configureDropdown(button: inout UIButton, handler: @escaping (UIAction) -> ()) {

        var menuChildren: [UIMenuElement] = []
        for (currency, name) in currencyList {
            menuChildren.append(UIAction(title: "\(currency) - \(name)", handler: handler))
        }

        button.menu = UIMenu(options: .displayInline, children: menuChildren)

        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
    }

    private func setupGestureRecognizer() {

        // Add a gesture recognizer to hide the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }

    // MARK: - Objc Methods

    @objc private func hideKeyboard() {

        logger.notice("⌨️ User tapped outside the keyboard area")

        view.endEditing(true)
    }
}

// MARK: - Extensions

// TextField Delegate
extension CurrencyConversionViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {

        // Check if the text is empty, if so don't save the amount
        guard let text = textField.text else { return }

        amountValue = text
        logger.notice("⌨️ Value \(self.amountValue) entered")
    }
}
