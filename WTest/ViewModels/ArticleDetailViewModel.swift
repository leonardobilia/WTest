//
//  ArticleDetailViewModel.swift
//  WTest
//
//  Created by Leonardo Bilia on 23/07/21.
//

import Foundation

final class ArticleDetailViewModel {
    
    private lazy var comments: [Comment] = []
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
    
    /// Table view number of sections.
    /// - Returns: Number of sections.
    func numberOfSections() -> Int {
        return 2
    }
    
    /// Table view number of rows in section.
    /// - Returns: Number of rows for each section.
    func numberOfRows(_ section: Int) -> Int {
        switch section {
        case 1:
            return comments.count
        default:
            return 1
        }
    }

    /// Cell for row at index path
    /// - Parameters:
    ///   - indexPath: Index path for the row.
    /// - Returns: An comment object.
    func cellForRowAt(_ indexPath: IndexPath) -> Comment {
        return comments[indexPath.row]
    }
    
    /// Title for section.
    /// - Parameter section: The section where to set the title.
    /// - Returns: The title for the section.
    func titleForHeader(in section: Int) -> String {
        if section == 1 {
            #if SECONDARY
            return Constants.Article.commentsHeaderTitle
            #endif
        }
        return ""
    }
    
    /// Will display cell at index path is used for indicating the moment to fetch more data during the pagination process.
    /// - Parameters:
    ///   - indexPath: Index path for the row.
    ///   - completion: It allows to reaload the tableview data.
    func willDisplayCellAt(_ indexPath: IndexPath, completion: @escaping () -> ()) {
        if indexPath.row == comments.count - 1 && fetchMoreData {
            currentPage += 1
            completion()
        }
    }
}

// MARK: - Network

extension ArticleDetailViewModel {
    
    /// Fetch Comments based on the article id, page, and the limit for the request.
    /// - Parameter completion: It's called when the fetch is completed successfully.
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

