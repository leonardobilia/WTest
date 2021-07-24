//
//  ZipCodeTableViewController.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import UIKit

class ZipCodeTableViewController: UITableViewController {
    
    private lazy var spinner = UIActivityIndicatorView()
    private lazy var viewModel = ZipCpdeViewModel()
    private lazy var searchController = UISearchController()
    private lazy var selectedZipCode: String = ""
    
    var modal = false
    weak var delegate: UIViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        setupNavigationBar()
        observableContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
    // MARK: - Methods
    
    private func fetchData() {
        viewModel.fetchContent {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private func observableContent() {
        viewModel.loading.valueChanged = { [weak self] value in
            value ? self?.spinner.startAnimating() : self?.spinner.stopAnimating()
        }
        
        viewModel.alert.valueChanged = { [weak self] message in
            if let message = message {
                let alert = UIAlertController(title: Constants.Alert.Title.oops, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Constants.Alert.Action.ok, style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func setupTableView() {
        spinner.startAnimating()
        tableView.backgroundView = spinner
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(ZipCodeTableViewCell.self, forCellReuseIdentifier: ZipCodeTableViewCell.reuseIdentifier)
    }
    
    private func setupSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.placeholder = Constants.ZipCode.searchPlaceholder
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupNavigationBar() {
        if modal {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.title = Constants.Title.zipCode
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        }
    }
    
    @objc private func doneButtonAction() {
        if let presenter = delegate as? FormViewController {
            presenter.selectedZipCode = selectedZipCode
        }
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table view data source

extension ZipCodeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(searchActive: searchController.isActive)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZipCodeTableViewCell.reuseIdentifier, for: indexPath) as! ZipCodeTableViewCell
        cell.populate(content: viewModel.cellForRowAt(indexPath, searchActive: searchController.isActive))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if modal {
            viewModel.didSelectRowAt(indexPath, searchActive: searchController.isActive) { content in
                selectedZipCode = "\(content.info)"
            }
        }
    }
}

// MARK: - UISearch Results Updating

extension ZipCodeTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.filterZipCodes(text: text)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UISearchBar Delegate

extension ZipCodeTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if modal {
            self.dismiss(animated: true) { [weak self] in
                self?.doneButtonAction()
            }
        }
    }
}
