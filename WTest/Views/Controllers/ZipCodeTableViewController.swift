//
//  ZipCodeTableViewController.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import UIKit

class ZipCodeTableViewController: UITableViewController, UISearchBarDelegate {

    private var spinner = UIActivityIndicatorView()
    private var viewModel = ZipCpdeViewModel()
    private let searchController = UISearchController()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViewModel()
    }
    
    // MARK: - Methods
    
    private func setupViewModel() {
        viewModel.fetchContent {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        
        viewModel.loading.valueChanged = { [weak self] value in
            value ? self?.spinner.startAnimating() : self?.spinner.stopAnimating()
        }
        
        viewModel.alert.valueChanged = { [weak self] message in
            if let message = message {
                let alert = UIAlertController(title: Constants.AlertTitle.oops, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Constants.AlertAction.ok, style: .default, handler: nil))
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
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
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
