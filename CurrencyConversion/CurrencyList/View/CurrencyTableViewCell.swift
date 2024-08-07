//
//  CurrencyTableViewCell.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 06/08/2024.
//

import UIKit

final class CurrencyTableViewCell: UITableViewCell {

    // MARK: - Public Variables

    var currencyName = UILabel()
    var currencyValue = UILabel()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupSubviews() {

        contentView.addSubview(currencyName)
        contentView.addSubview(currencyValue)
    }

    private func setupConstraints() {

        currencyName.translatesAutoresizingMaskIntoConstraints = false
        currencyValue.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currencyName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100),
            currencyName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            currencyName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            currencyValue.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            currencyValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            currencyValue.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
