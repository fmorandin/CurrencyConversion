//
//  CurrencyTableViewCell.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 06/08/2024.
//

import UIKit

final class CurrencyTableViewCell: UITableViewCell {

    // MARK: - Public Variable

    var currencyName = UILabel()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Private Methods

    private func setupSubviews() {

        contentView.addSubview(currencyName)
    }

    private func setupConstraints() {

        currencyName.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currencyName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            currencyName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            currencyName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            currencyName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
