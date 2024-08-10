//
//  CurrencyConversionViewController.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 07/08/2024.
//

import UIKit
import os

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
        element.text = String(localized: "From")
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
        element.text = String(localized: "To")
        return element
    }()

    private lazy var toButton: UIButton = {
        let element = UIButton(configuration: .plain())
        element.translatesAutoresizingMaskIntoConstraints = false
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

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupConstraints()

        view.backgroundColor = .appColor(.backgroundColor)
    }

    // MARK: - Private Methods

    private func setupSubviews() {

        view.backgroundColor = .appColor(.backgroundColor)

        view.addSubview(pageTitle)
        view.addSubview(separator)
        
        view.addSubview(fromLabel)
        configureDropdown(button: &fromButton, handler: actionClosureFrom)
        view.addSubview(fromButton)

        view.addSubview(toLabel)
        configureDropdown(button: &toButton, handler: actionClosureTo)
        view.addSubview(toButton)

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
            fromButton.leadingAnchor.constraint(equalTo: fromLabel.trailingAnchor, constant: 15),
            fromButton.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor),

            toLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            toLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor, constant: 30),
            toButton.leadingAnchor.constraint(equalTo: toLabel.trailingAnchor, constant: 15),
            toButton.centerYAnchor.constraint(equalTo: toLabel.centerYAnchor),

            totalTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            totalTitleLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: 30),

            totalLabel.leadingAnchor.constraint(equalTo: totalTitleLabel.trailingAnchor, constant: 20),
            totalLabel.centerYAnchor.constraint(equalTo: totalTitleLabel.centerYAnchor),
        ])
    }

    private func configureDropdown(button: inout UIButton, handler: @escaping (UIAction) -> ()) {

        var menuChildren: [UIMenuElement] = []
        let dataSource = UserDefaultsWrapper().getValues(for: .availableCurrencies) ?? []
        for currency in dataSource {
            menuChildren.append(UIAction(title: currency, handler: handler))
        }

        button.menu = UIMenu(options: .displayInline, children: menuChildren)

        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
    }
}

