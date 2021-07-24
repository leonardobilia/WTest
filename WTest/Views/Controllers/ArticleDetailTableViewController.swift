//
//  ArticleDetailTableViewController.swift
//  WTest
//
//  Created by Leonardo Bilia on 22/07/21.
//

import UIKit

class ArticleDetailTableViewController: UITableViewController {
    
    private lazy var spinner = UIActivityIndicatorView()
    private lazy var viewModel = ArticleDetailViewModel()
    var article: Article.Item!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeader()
        observableContent()
        fetchData()
    }
    
    // MARK: - Methods
    
    private func setupHeader() {
        let headerView = StretchyHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 250))
        if let hero = article.hero, let url = URL(string: hero) {
            headerView.imageView.load(url: url)
        }
        tableView.tableHeaderView = headerView
    }
    
    private func setupTableView() {
        spinner.startAnimating()
        tableView.backgroundView = spinner
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(ArticleDetailTableViewCell.self, forCellReuseIdentifier: ArticleDetailTableViewCell.reuseIdentifier)
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: CommentsTableViewCell.reuseIdentifier)
    }

    private func fetchData() {
        viewModel.fetchComments(id: article.id) { [weak self] in
            DispatchQueue.main.async {
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
}

// MARK: - Table view data source

extension ArticleDetailTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ArticleDetailTableViewCell.reuseIdentifier, for: indexPath) as! ArticleDetailTableViewCell
            cell.populate(content: article)
            cell.selectionStyle = .none
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.reuseIdentifier, for: indexPath) as! CommentsTableViewCell
            cell.populate(content: viewModel.cellForRowAt(indexPath))
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplayCellAt(indexPath) { [weak self] in
            self?.fetchData()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(in: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = tableView.tableHeaderView as! StretchyHeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
}
