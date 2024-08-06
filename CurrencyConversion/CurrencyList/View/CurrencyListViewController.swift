//
//  CurrencyListViewController.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 06/08/2024.
//

import UIKit

class CurrencyListViewController: UIViewController {

    // MARK: - UI Elements

    private lazy var appTitle: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.isUserInteractionEnabled = false
        element.textAlignment = .left
        element.font = .monospacedSystemFont(ofSize: 30, weight: .bold)
        element.tintColor = .appColor(.accentColor)
        return element
    }()

    private lazy var separator: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.isUserInteractionEnabled = false
        element.backgroundColor = .black
        return element
    }()

    private lazy var currenciesTableView = UITableView(frame: view.bounds, style: .plain)

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
        appTitle.text = String(localized: "Currency Conversion")

        currenciesTableView.dataSource = self
        currenciesTableView.delegate = self
        currenciesTableView.translatesAutoresizingMaskIntoConstraints = false
        currenciesTableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: "currencyCell")

        view.addSubview(appTitle)
        view.addSubview(separator)
        view.addSubview(currenciesTableView)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            appTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            appTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),

            separator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            separator.topAnchor.constraint(equalTo: appTitle.bottomAnchor, constant: 15),
            separator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            separator.heightAnchor.constraint(equalToConstant: 1),

            currenciesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            currenciesTableView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20),
            currenciesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            currenciesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - Extensions

// TableView Datasource
extension CurrencyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currenciesTableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyTableViewCell

        cell.currencyName.text = "name"

        return cell
    }
}

// TableView Delegate
extension CurrencyListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("select")
    }
}
