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
        setupNavigationController()
        addSabviews()
        setupLayout()
    }
    
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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var collectinView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 110), collectionViewLayout: UICollectionViewFlowLayout())
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
    
}

private extension EnterAmountViewController {
    
    @objc private func enterNumber(_ sender: UIButton) {
        print(#function )
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
        view.addSubview(collectinView)
        view.addSubview(tableView)
        view.addSubview(amountLabel)
        view.addSubview(numpadStackView)
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
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.height/10, height: UIScreen.main.bounds.size.height/10)))
        button.layer.masksToBounds = true
        button.layer.borderWidth = 3
        button.layer.cornerRadius = button.frame.size.width / 2.2
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
        amountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        amountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        
        numpadStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        numpadStackView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 30).isActive = true
        
        collectinView.topAnchor.constraint(equalTo: numpadStackView.bottomAnchor, constant: 10).isActive = true
        collectinView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        collectinView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: collectinView.bottomAnchor, constant: 10).isActive = true
    }
}

extension EnterAmountViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Spent today" : "Spent yesterday"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        return cell
    }
}

extension EnterAmountViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.categoryCell.rawValue, for: indexPath) as! SpendCategoryCollectionViewCell

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension EnterAmountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
}


