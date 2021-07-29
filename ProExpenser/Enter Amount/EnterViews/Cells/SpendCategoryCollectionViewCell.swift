//
//  FileSpentItemCollectionViewCell.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/24/21.
//

import UIKit

class SpendCategoryCollectionViewCell: UICollectionViewCell {
    private var name: String? = nil { didSet { label.text = name } }
    private var image: UIImage? = nil { didSet { imageView.image = image } }
    
    var spendCategory: SpendCategory? {
        didSet {
            name = spendCategory?.name
            image = UIImage(named: spendCategory?.imageName ?? "")
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.contentMode = .scaleToFill
        stackView.spacing = 3
        stackView.axis = .vertical
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let image = UIImage(named: "nosign")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let label: UILabel = {
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
        backgroundColor = .white
    }
    
    private func setupLayout() {
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
