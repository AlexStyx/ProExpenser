//
//  ViewController.swift
//  ProExpenser
//
//  Created by Александр Бисеров on 7/23/21.
//

import UIKit

protocol EnterViewProtocol: AnyObject {
    func addSubviews()
    func setupLayout()
    func setupNavigationController()
    func updateEnterAmountLabelValue(newValue: String)
    func updateLists()
}

class EnterAmountViewController: UIViewController {
    var presenter: EnterPresenterProtocol!
    var configurator: EnterConfiguratorProtocol = EnterConfigurator()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configurator.configure(with: self)
        presenter.configureView()
    }
    
    //MARK: - Create Views
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
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        var font = UIFont(name: "Helvetica", size: 25)
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
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.separatorColor = .black
        return tableView
    }()
    
    private lazy var collectinView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: collectionViewHeight), collectionViewLayout: UICollectionViewFlowLayout())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: collectionView.bounds.size.height - 20, height: collectionView.bounds.size.height - 20)
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

// MARK: - EnterViewProtocol
extension EnterAmountViewController: EnterViewProtocol {
    
    
    // MARK: - Setup and layout UI
    func setupNavigationController() {
        navigationItem.title = "Expenses"
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.setNavigationBarBorderColor(.black)
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chart.pie"),
            style: .done,
            target: self,
            action: #selector(openChartTapped)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(amountLabel)
        contentView.addSubview(numpadStackView)
        createNumpadView()
        contentView.addSubview(collectinView)
        contentView.addSubview(tableView)
    }
    
    func setupLayout() {
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        amountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        
        numpadStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        numpadStackView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 10).isActive = true
        for stack in (numpadStackView.arrangedSubviews as! [UIStackView]) {
            for button in stack.arrangedSubviews {
                button.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2).isActive = true
                button.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2).isActive = true
            }
        }
        
        collectinView.topAnchor.constraint(equalTo: numpadStackView.bottomAnchor, constant: 10).isActive = true
        collectinView.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor).isActive = true
        collectinView.heightAnchor.constraint(greaterThanOrEqualToConstant: collectionViewHeight).isActive = true
        
        tableView.topAnchor.constraint(equalTo: collectinView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: tableViewHeight).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    // MARK: - Update UI
    func updateEnterAmountLabelValue(newValue: String) {
        amountLabel.text = newValue
    }
    
    func updateLists() {
        collectinView.reloadData()
        tableView.reloadData()
    }
}

// MARK: - Actions
extension EnterAmountViewController {
    @objc private func openChartTapped() {
        presenter.goToChartButtonClicked()
    }
    
    @objc func numpadButtonTapped(_ sender: UIButton) {
        animateButton(sender)
        presenter.handleInputValue(handledValue: sender.currentTitle)
    }
}

// MARK: - Createing views
extension EnterAmountViewController {
    
    private func createNumpadView() {
        let allTitles: [[Any]] = [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"], [".", "0", (UIImage(systemName: "delete.left") as Any)]]
        for titles in allTitles {
            let numpadRow = createNumpadRow(titles: titles)
            numpadStackView.addArrangedSubview(numpadRow)
        }
    }
    
    private func createNumpadRow(titles: [Any]) -> UIStackView {
        if titles.count != 3 {
            fatalError("Number of titles does not equal 3: createNumpadRow(titles: [Any])")
        }
        let numpadRow = createHorizontalStackView(arrangedSubviews: [])
        for title in titles {
            var button = UIButton()
            switch title {
            case let buttonTitle as (String): button = createButton(title: buttonTitle, image: nil, action: #selector(numpadButtonTapped))
            case let buttonTitle as (UIImage): button = createButton(title: nil, image: buttonTitle, action: #selector(numpadButtonTapped))
            default: fatalError("Wrong type of title in createNumpadRow(titles: [Any])")
            }
            numpadRow.addArrangedSubview(button)
        }
        return numpadRow
    }
    
    private func createButton(title: String?, image: UIImage?, action: Selector) -> UIButton {
        let buttonFrame = CGRect(origin: CGPoint.zero, size: buttonSize)
        let button = UIButton(frame: buttonFrame)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = button.bounds.size.width.rounded() * 0.5
        button.backgroundColor = .gray.withAlphaComponent(0.1)
        
        if title != nil {
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont(name: "Helvetica", size: 25)
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
    
    private func createHorizontalStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.axis = .horizontal
        return stackView
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension EnterAmountViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Spent today:"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let transactionCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? TransactionCell else { fatalError("Cannot found TableViewCellClass") }
        let transaction = presenter.transaction(at: indexPath)
        transactionCell.transaction = transaction
        return transactionCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableViewHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .black
    }
}

// MARK: -  UICollectionViewDataSource, UICollectionViewDelegate
extension EnterAmountViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.categoryCell.rawValue, for: indexPath) as! SpendCategoryCollectionViewCell
        let category = presenter.category(at: indexPath)
        cell.spendCategory = category
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        animateAmountLabel()
        presenter.collectionViewCellClicked(at: indexPath)
        animateTableView()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EnterAmountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

// MARK: - Size constants
extension EnterAmountViewController {
    private var tableViewCellHeight: CGFloat { (view.frame.size.height / 9).rounded() }
    private var buttonSideSize: CGFloat { (UIScreen.main.bounds.size.width * 0.2).rounded() }
    private var tableViewHeight: CGFloat { tableViewCellHeight * CGFloat(numberOfRows) + 25 }
    private var buttonSize: CGSize { CGSize(width: buttonSideSize, height: buttonSideSize) }
    private var tableViewHeaderHeight: CGFloat { 25 }
    private var collectionViewHeight: CGFloat { UIScreen.main.bounds.size.height / 7 + 20 }
    private var collectionViewInsets: CGFloat { UIScreen.main.bounds.size.width / 6 }
    private var numberOfRows: Int { presenter.numberOfRows() }
}

// MARK: - Animations
extension EnterAmountViewController {
    private func animateAmountLabel() {
        if amountLabel.text != "Enter amount" {
            UIView.animate(
                withDuration: 0.5) { [weak self] in
                self?.amountLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
                self?.amountLabel.alpha = 0.1
            } completion: { [weak self]_ in
                self?.amountLabel.text = "Enter amount"
                self?.amountLabel.alpha = 1
                self?.amountLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    private func animateTableView() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let cellHeight = self?.tableViewCellHeight else { return }
            self?.tableView.frame.size.height += cellHeight
        }
    }
    
    private func animateButton(_ sender: UIButton) {
        sender.backgroundColor = .gray.withAlphaComponent(0.8)
        UIView.animate(withDuration: 0.05, delay: 0) {
            sender.backgroundColor = .gray.withAlphaComponent(0.1)
        }
    }
}

//MARK: - UINavigationController+extension
extension UINavigationController {
    func setNavigationBarBorderColor(_ color:UIColor) {
        self.navigationBar.shadowImage = color.as1ptImage()
    }
}

extension UIColor {
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
