//
//  ArticlesTableViewController.swift
//  WTest
//
//  Created by Leonardo Bilia on 22/07/21.
//

import UIKit

class ArticlesTableViewController: UITableViewController {
    
    private var spinner = UIActivityIndicatorView()
    private var viewModel = ArticlesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModel()
    }
    
    // MARK: - Methods
    
    private func setupViewModel() {
        viewModel.fetchArticles {
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
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.reuseIdentifier)
    }
}

// MARK: - Table view data source

extension ArticlesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.reuseIdentifier, for: indexPath) as! ArticleTableViewCell
        cell.populate(content: viewModel.cellForRowAt(indexPath))
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath) { article in
            let controller = ArticleDetailTableViewController()
            controller.article = article
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplayCellAt(indexPath) { [weak self] in
            self?.viewModel.fetchArticles {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
