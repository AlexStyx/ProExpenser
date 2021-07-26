//
//  ViewController.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/23/21.
//

import UIKit

class EnterAmountViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationController()
        addSabviews()
        setupLayout()
    }
    
    let data = ["data", "name", "another_data", "name", "another_data", "name", "another_data"]
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private func setupNavigationController() {
        navigationItem.title = "Expenses"
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chart.pie"),
            style: .done,
            target: self,
            action: #selector(openChartTapped)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func openChartTapped() {
        print(#function)
    }
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        let font = UIFont(name: "Helvetica", size: 40)
        label.text = "Enter amount"
        label.textColor = .gray
        label.font = font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numpadStackView: UIStackView =  {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var collectinView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 100), collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: collectionView.bounds.size.height - 10, height: collectionView.bounds.size.height - 10)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.register(SpendCategoryCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCellIdentifier.categoryCell.rawValue)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    let finishView: UIView = {
        let finishView = UIView()
        finishView.translatesAutoresizingMaskIntoConstraints = false
        return finishView
    }()
    
}

private extension EnterAmountViewController {
    
    private func onPressButton(_ sender: UIButton) {
        sender.backgroundColor = .gray.withAlphaComponent(0.8)
        
        UIView.animate(withDuration: 0.05, delay: 0) {
            sender.backgroundColor = .gray.withAlphaComponent(0.1)
        }
    }
    
    @objc private func enterNumber(_ sender: UIButton) {
        onPressButton(sender)
        if amountLabel.text!.count <= 16 {
            if sender.currentTitle == "." {
                if amountLabel.text!.filter({$0 == "."}).count >= 1 && sender.currentTitle == "." {
                    amountLabel.text! += ""
                } else if amountLabel.text == "Enter amount" {
                    amountLabel.text = "Enter amount"
                } else {
                    amountLabel.font = amountLabel.text!.count >= 12 ? UIFont(name: "Helvetica", size: 30) : UIFont(name: "Helvetica", size: 40)
                    amountLabel.text! += "\(sender.currentTitle!)"
                }
            } else {
                if amountLabel.text == "Enter amount" {
                    amountLabel.text = ""
                }
                amountLabel.font = amountLabel.text!.count >= 12 ? UIFont(name: "Helvetica", size: 30) : UIFont(name: "Helvetica", size: 40)
                amountLabel.text! += "\(sender.currentTitle!)"
            }
        }
        
        if let index = amountLabel.text!.firstIndex(of: ".") {
            if amountLabel.text![index..<amountLabel.text!.endIndex].count == 3 {
                amountLabel.text! = String(format: "%.2f", (Double(amountLabel.text!) ?? 0))
            } else if amountLabel.text![index..<amountLabel.text!.endIndex].count >= 3 {
                amountLabel.text!.remove(at: amountLabel.text!.index(before: amountLabel.text!.endIndex))
            }
        }
        
        if amountLabel.text!.first == "0" {
            let start = amountLabel.text!.index(amountLabel.text!.startIndex, offsetBy: 1)
            if amountLabel.text!.count >= 2 && amountLabel.text![start] != "." {
                amountLabel.text!.removeLast()
            }
        }
    }
    
    @objc private func deleteDigit(_ sender: UIButton) {
        onPressButton(sender)
        amountLabel.font = amountLabel.text!.count >= 13 ? UIFont(name: "Helvetica", size: 30) : UIFont(name: "Helvetica", size: 40)
        if amountLabel.text!.count == 1 {
            amountLabel.text! = "Enter amount"
        } else if amountLabel.text! == "Enter amount" {
            amountLabel.text! = amountLabel.text!
        } else {
            amountLabel.text!.removeLast()
        }
        
    }
    
    private func addSabviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(amountLabel)
        contentView.addSubview(numpadStackView)
        var digit = 0
        for _ in 1...3 {
            let stackView = createHorizontalStackView()
            for _ in 1...3 {
                digit += 1
                let digitButton = createButton(title: "\(digit)", image: nil, action: #selector(enterNumber))
                stackView.addArrangedSubview(digitButton)
            }
            numpadStackView.addArrangedSubview(stackView)
        }
        let stackView = createHorizontalStackView()

        let pointButton = createButton(title: ".", image: nil, action: #selector(enterNumber))
        let zeroButton = createButton(title: "0", image: nil, action: #selector(enterNumber))
        let image = UIImage(systemName: "delete.left")
        let backSpaceButton = createButton(title: nil, image: image, action: #selector(deleteDigit))

        stackView.addArrangedSubview(pointButton)
        stackView.addArrangedSubview(zeroButton)
        stackView.addArrangedSubview(backSpaceButton)

        numpadStackView.addArrangedSubview(stackView)

        contentView.addSubview(collectinView)
        contentView.addSubview(tableView)
//        contentView.addSubview(finishView)

    }
    
    private func createHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.axis = .horizontal
        return stackView
    }
    
    private func createButton(title: String?, image: UIImage?, action: Selector) -> UIButton {
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.size.height/10, height: UIScreen.main.bounds.size.height/10)))
        button.layer.masksToBounds = true
        button.layer.borderWidth = 3
        button.backgroundColor = UIColor(white: 1, alpha: 0.1)
        button.backgroundColor = .gray.withAlphaComponent(0.1)
        
        button.layer.cornerRadius = button.bounds.size.width.rounded() * 0.5
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.gray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2).isActive = true
        button.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2).isActive = true
        if title != nil {
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 40)
            button.setTitleColor(.gray, for: .normal)
            button.contentHorizontalAlignment = .center
        }
        
        if image != nil {
            button.setImage(image, for: .normal)
            button.tintColor = .gray
        }
        
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return button
    }
    
    private func setupLayout() {
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        amountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50).isActive = true
        
        numpadStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        numpadStackView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 30).isActive = true

        collectinView.topAnchor.constraint(equalTo: numpadStackView.bottomAnchor, constant: 10).isActive = true
        collectinView.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor).isActive = true
        collectinView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        let tableViewHeight: CGFloat = CGFloat(44 * data.count + 25)
        tableView.topAnchor.constraint(equalTo: collectinView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: tableViewHeight).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}

extension EnterAmountViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Spent today:"
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        print(cell.frame.size.height)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
}

extension EnterAmountViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.categoryCell.rawValue, for: indexPath) as! SpendCategoryCollectionViewCell
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if amountLabel.text != "Enter amount" {
            UIView.animate(
                withDuration: 0.5) { [weak self] in
                self?.amountLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
                self?.amountLabel.alpha = 0.1
            } completion: { [weak self]_ in
                self?.amountLabel.text = "Enter amount"
                self?.amountLabel.alpha = 1
                self?.amountLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                self?.amountLabel.font = UIFont(name: "Helvetica", size: 40)
            }
            
        }
    }
}

extension EnterAmountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
