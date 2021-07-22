//
//  ArticleDetailTableViewController.swift
//  WTest
//
//  Created by Leonardo Bilia on 22/07/21.
//

import UIKit

class ArticleDetailTableViewController: UITableViewController {
    
    var article: Article.Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeader()
    }
    
    func setupHeader() {
        let headerView = StretchyHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 250))
        if let hero = article.hero, let url = URL(string: hero) {
            headerView.imageView.load(url: url)
        }
        tableView.tableHeaderView = headerView
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(ArticleDetailTableViewCell.self, forCellReuseIdentifier: ArticleDetailTableViewCell.reuseIdentifier)
    }
}

// MARK: - Table view data source

extension ArticleDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleDetailTableViewCell.reuseIdentifier, for: indexPath) as! ArticleDetailTableViewCell
        cell.populate(content: article)
        cell.selectionStyle = .none
        return cell
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
