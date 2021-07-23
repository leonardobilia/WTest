//
//  ArticlesViewModel.swift
//  WTest
//
//  Created by Leonardo Bilia on 22/07/21.
//

import Foundation

class ArticlesViewModel {
    
    private var articles: [Article.Item] = []
    private let networkService: NetworkServiceProtocol
    private var fetchMoreData = false
    private var currentPage = 1

    var loading: Bindable<Bool> = Bindable(false)
    var alert: Bindable<String?> = Bindable(nil)
    
    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Methods
    
    func numberOfRows() -> Int {
        return articles.count
    }
    
    func cellForRowAt(_ indexPath: IndexPath) -> Article.Item {
        return articles[indexPath.row]
    }
    
    func willDisplayCellAt(_ indexPath: IndexPath, completion: @escaping () -> ()) {
        if indexPath.row == articles.count - 1 && fetchMoreData {
            currentPage += 1
            completion()
        }
    }
    
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
