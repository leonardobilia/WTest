//
//  ArticlesViewModel.swift
//  WTest
//
//  Created by Leonardo Bilia on 22/07/21.
//

import Foundation

final class ArticlesViewModel {
    
    private lazy var articles: [Article.Item] = []
    private lazy var fetchMoreData = false
    private lazy var currentPage = 1

    var loading: Bindable<Bool> = Bindable(false)
    var alert: Bindable<String?> = Bindable(nil)
    
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Methods
    
    /// Table view number of rows.
    /// - Returns: Number of rows.
    func numberOfRows() -> Int {
        return articles.count
    }
    
    /// Cell for row at index path.
    /// - Parameters:
    ///   - indexPath: Index path for the row.
    /// - Returns: An article object.
    func cellForRowAt(_ indexPath: IndexPath) -> Article.Item {
        return articles[indexPath.row]
    }
    
    /// Will display cell at index path is used for indicating the moment to fetch more data during the pagination process.
    /// - Parameters:
    ///   - indexPath: Index path for the row.
    ///   - completion: It allows to reaload the table view data.
    func willDisplayCellAt(_ indexPath: IndexPath, completion: @escaping () -> ()) {
        if indexPath.row == articles.count - 1 && fetchMoreData {
            currentPage += 1
            completion()
        }
    }
    
    /// Did select row at index path.
    /// - Parameters:
    ///   - indexPath: Index path for the row.
    ///   - completion: Returns the selected object.
    func didSelectRowAt(_ indexPath: IndexPath, completion: (Article.Item) -> ()) {
        completion(articles[indexPath.row])
    }
}

// MARK: - Network

extension ArticlesViewModel {
    #if PRIMARY
    typealias DataModel = Article
    #else
    typealias DataModel = Article.Item
    #endif
    
    /// Fetch articles based on the page and the limit for the request.
    /// - Parameter completion: It's called when the fetch is completed successfully.
    func fetchArticles(completion: @escaping () -> Void) {
        loading.value = true
        networkService.fetch(.articles(limit: 10, page: currentPage), type: DataModel.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    #if PRIMARY
                    response.items.forEach({ self?.articles.append($0) })
                    self?.fetchMoreData = response.items.count != 0
                    #else
                    response.forEach({ self?.articles.append($0) })
                    self?.fetchMoreData = response.count != 0
                    #endif
                    self?.loading.value = false
                    completion()
                }
            case .failure(let error):
                self?.loading.value = false
                self?.alert.value = error.localizedDescription
            }
        }
    }
}
