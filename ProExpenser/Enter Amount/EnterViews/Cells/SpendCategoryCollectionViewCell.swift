//
//  FileSpentItemCollectionViewCell.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/24/21.
//

import UIKit

class SpendCategoryCollectionViewCell: UICollectionViewCell {
    let name: String? = nil
    let image: UIImage? = nil
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.contentMode = .scaleToFill
        stackView.spacing = 3
        stackView.axis = .vertical
        return stackView
    }()
    
    let imageView: UIImageView = {
        let image = UIImage(named: "nosign")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        let font = UIFont(name: "Helvetica", size: 15)
        label.text = "Test"
        label.textColor = .gray
        label.font = font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private func configureView() {
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        setupLayout()
    }
    
    private func setupLayout() {
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
