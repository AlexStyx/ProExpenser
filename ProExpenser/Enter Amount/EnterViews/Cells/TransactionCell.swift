//
//  TransactionCell.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/31/21.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    private  let offset: CGFloat = 15
    var transaction: Transaction? {
        willSet {
            if let category = newValue?.category {
                guard let imageName = category.imageName,
                      let name = category.name,
                      let value = newValue?.transitedValue
                else {
                    fatalError("Wrong data from transaction")
                }
                categoeyImageView.image = UIImage(named: imageName)
                categoryLabel.text = name
                amountLabel.text = String(format: "%.2f", value)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setNeedsDisplay()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let categoeyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        let font = UIFont(name: "Helvetica", size: 25)
        label.font = font
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        let font = UIFont(name: "Helvetica", size: 25)
        label.font = font
        return label

    }()
    
    
    private func configureView() {
        backgroundColor = .white
        addSubview(categoeyImageView)
        addSubview(categoryLabel)
        addSubview(amountLabel)
        setupLayot()
    }

    private func setupLayot() {
        categoeyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset).isActive = true
        categoeyImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        categoeyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: categoeyImageView.trailingAnchor, constant: offset).isActive = true
        amountLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset).isActive = true
        amountLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
}
