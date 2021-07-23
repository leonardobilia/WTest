//
//  ArticleDetailViewModel.swift
//  WTest
//
//  Created by Leonardo Bilia on 23/07/21.
//

import Foundation

class ArticleDetailViewModel {
    
    private var comments: [Comment] = []
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
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfRows(_ section: Int) -> Int {
        switch section {
        case 1:
            return comments.count
        default:
            return 1
        }
    }

    func cellForRowAt(_ indexPath: IndexPath) -> Comment {
        return comments[indexPath.row]
    }
    
    func titleForHeader(in section: Int) -> String {
        if section == 1 {
            #if SECONDARY
            return Constants.Article.commentsHeaderTitle
            #endif
        }
        return ""
    }
    
    func willDisplayCellAt(_ indexPath: IndexPath, completion: @escaping () -> ()) {
        if indexPath.row == comments.count - 1 && fetchMoreData {
            currentPage += 1
            completion()
        }
    }
}

// MARK: - Network

extension ArticleDetailViewModel {
    func fetchComments(id: String, completion: @escaping () -> Void) {
        #if SECONDARY
        loading.value = true
        networkService.fetch(.comments(id: id, limit: 15, page: currentPage), type: Comment.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    response.forEach({ self?.comments.append($0) })
                    self?.fetchMoreData = response.count != 0
                    self?.loading.value = false
                    completion()
                }
            case .failure(let error):
                self?.loading.value = false
                self?.alert.value = error.localizedDescription
            }
        }
        #endif
    }
}

