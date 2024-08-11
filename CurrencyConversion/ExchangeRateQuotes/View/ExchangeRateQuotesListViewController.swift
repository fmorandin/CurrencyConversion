//
//  ExchangeRateQuotesListViewController.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 06/08/2024.
//

import UIKit
import os
import Combine

class ExchangeRateQuotesListViewController: UIViewController {

    // MARK: - UI Elements

    private lazy var pageTitle: UILabel = {
        let element = UILabel()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.isUserInteractionEnabled = false
        element.textAlignment = .left
        element.font = .monospacedSystemFont(ofSize: 30, weight: .bold)
        element.tintColor = .appColor(.accentColor)
        element.text = String(localized: "Currency List")
        return element
    }()

    private lazy var separator: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.isUserInteractionEnabled = false
        element.backgroundColor = .black
        return element
    }()

    private lazy var currenciesTableView: UITableView = {
        let element = UITableView(frame: view.bounds, style: .plain)
        element.allowsSelection = false
        element.dataSource = self
        element.translatesAutoresizingMaskIntoConstraints = false
        element.register(ExchangeRateQuotesTableViewCell.self, forCellReuseIdentifier: "currencyCell")
        return element
    }()

    // MARK: - Private Variables

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ExchangeRateQuotesListViewController.self)
    )

    private let viewModel: ExchangeRateQuotesViewModelProtocol

    private var cancellables = Set<AnyCancellable>()

    private var currenciesRates = [String: Double]()
    private var currenciesKeys = [String]()
    private var currenciesValues = [Double]()

    // MARK: - Init

    init(viewModel: ExchangeRateQuotesViewModelProtocol = ExchangeRateQuotesListViewModel()) {

        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle

    override func viewWillAppear(_ animated: Bool) {

        viewModel.fetchExchangeRateQuotes()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
        view.addSubview(currenciesTableView)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            pageTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            pageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),

            separator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            separator.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 15),
            separator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            separator.heightAnchor.constraint(equalToConstant: 1),

            currenciesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            currenciesTableView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20),
            currenciesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            currenciesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func setupObservers() {

        viewModel.exchangeRateQuotesDataPublisher.sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.logger.error("\(error)")
            case .finished:
                self?.logger.info("💶 Currency info received correctly from ViewModel")
            }
        } receiveValue: { [weak self] result in
            self?.currenciesRates = result.rates
            self?.currenciesKeys = Array(result.rates.keys)
            self?.currenciesValues = Array(result.rates.values)
            DispatchQueue.main.async { [weak self] in
                self?.currenciesTableView.reloadData()
            }

        }
        .store(in: &cancellables)
    }

}

// MARK: - Extensions

// TableView Datasource
extension ExchangeRateQuotesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currenciesRates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currenciesTableView.dequeueReusableCell(
            withIdentifier: "currencyCell",
            for: indexPath) as! ExchangeRateQuotesTableViewCell

        // As an improvement, the user could select the base currency while doing the search, if that improvement was
        // developed, this line would have to be changed as well to display the base from the API request instead of
        // a hardcoded text
        cell.currencyName.text = "EUR --> \(currenciesKeys[indexPath.row])"
        cell.currencyValue.text = "\(currenciesValues[indexPath.row])"

        return cell
    }
}
