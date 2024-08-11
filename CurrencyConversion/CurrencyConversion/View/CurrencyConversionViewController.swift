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
        let element = UIButton(configuration: .gray())
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
        let element = UIButton(configuration: .gray())
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

    private lazy var convertButton: UIButton = {
        let element = UIButton(configuration: .borderedProminent())
        element.translatesAutoresizingMaskIntoConstraints = false
        element.setTitle(String(localized: "Convert"), for: .normal)
        element.addTarget(self, action: #selector(performConversion), for: .touchUpInside)
        element.tintColor = .appColor(.accentColor)
        element.setTitleColor(.appColor(.backgroundColor), for: .normal)
        return element
    }()

    private lazy var totalTitleLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.isUserInteractionEnabled = false
        element.textAlignment = .left
        element.font = .preferredFont(forTextStyle: .title3)
        element.tintColor = .appColor(.accentColor)
        element.text = String(localized: "Total:")
        return element
    }()

    private lazy var totalLabel: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.isUserInteractionEnabled = false
        element.textAlignment = .left
        element.font = .preferredFont(forTextStyle: .headline)
        element.tintColor = .appColor(.accentColor)
        element.text = String(localized: "Result")
        return element
    }()

    // MARK: - Private Variables

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: CurrencyConversionViewController.self)
    )

    // The variables and the closures related with the from and to were necessary in order to implement the UIMenu
    // and use it instead of doing the dropdown using table views or an external component
    private var fromValue: String = ""
    private lazy var actionClosureFrom = { [weak self] (action: UIAction) in

        guard let self,
              let currency = action.title.split(separator: "-").first else { return }

        self.fromValue = currency.trimmingCharacters(in: .whitespacesAndNewlines)
        self.logger.info("🏧 From value: \(self.fromValue)")
    }

    private var toValue: String = ""
    private lazy var actionClosureTo = { [weak self] (action: UIAction) in

        guard let self,
              let currency = action.title.split(separator: "-").first else { return }

        self.toValue = currency.trimmingCharacters(in: .whitespacesAndNewlines)
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

        view.addSubview(amountLabel)
        view.addSubview(amountTextField)

        view.addSubview(fromLabel)
        view.addSubview(fromButton)

        view.addSubview(toLabel)
        view.addSubview(toButton)

        view.addSubview(convertButton)

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

            amountLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            amountLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 30),
            amountTextField.leadingAnchor.constraint(equalTo: amountLabel.trailingAnchor, constant: 20),
            amountTextField.centerYAnchor.constraint(equalTo: amountLabel.centerYAnchor),

            fromLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            fromLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 30),
            fromButton.leadingAnchor.constraint(equalTo: amountTextField.leadingAnchor),
            fromButton.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor),

            toLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            toLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor, constant: 30),
            toButton.leadingAnchor.constraint(equalTo: amountTextField.leadingAnchor),
            toButton.centerYAnchor.constraint(equalTo: toLabel.centerYAnchor),

            convertButton.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: 30),
            convertButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            totalTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            totalTitleLabel.topAnchor.constraint(equalTo: convertButton.bottomAnchor, constant: 30),

            totalLabel.leadingAnchor.constraint(equalTo: totalTitleLabel.trailingAnchor, constant: 10),
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

        viewModel.currencyConversionDataPublisher.sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.logger.error("\(error)")
            case .finished:
                self?.logger.info("💶 Available currency list info received correctly from ViewModel")
            }
        } receiveValue: { [weak self] currencyConverted in
            guard let self else { return }

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.totalLabel.text = "\(self.amountValue)\(self.fromValue) \(String(localized: "is equal to")) \(currencyConverted.rates[self.toValue] ?? 0)\(self.toValue)"
            }
        }
        .store(in: &cancellables)

    }

    // This is the function that actually creates the `dropdown` for the currencies.
    // Since UIKit doesn't have a native component for that we need to either implement a custom solution
    // or use an external component for that. In my case, I used this solution that I thought that fits better in the app
    private func configureDropdown(button: inout UIButton, handler: @escaping (UIAction) -> ()) {

        var menuChildren = [UIMenuElement]()
        fromValue = currencyList.first?.key ?? ""
        toValue = currencyList.first?.key ?? ""
        for (currency, name) in currencyList.sorted(by: { $0.key < $1.key }) {
            menuChildren.append(UIAction(title: "\(currency) - \(name)", handler: handler))
        }

        button.menu = UIMenu(options: .singleSelection, children: menuChildren)

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

    @objc private func performConversion() {

        logger.info("🔄 Converting \(self.amountValue) from \(self.fromValue) to \(self.toValue)")

        viewModel.performConversion(amount: amountValue, from: fromValue, to: toValue)
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
