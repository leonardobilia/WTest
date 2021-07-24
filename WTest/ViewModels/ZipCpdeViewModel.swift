//
//  ZipCpdeViewModel.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import Foundation

final class ZipCpdeViewModel {

    private lazy var zipcodes: [ZipCode] = []
    private lazy var filteredZipcodes: [ZipCode] = []
    
    var loading: Bindable<Bool> = Bindable(false)
    var alert: Bindable<String?> = Bindable(nil)
    
    // MARK: - Methods
    
    /// Table view number of rows.
    /// - Parameter searchActive: It checks if the search bar is active or not.
    /// - Returns: Number of rows
    func numberOfRows(searchActive: Bool) -> Int {
        return searchActive ? filteredZipcodes.count : zipcodes.count
    }
    
    /// Cell for row at index path
    /// - Parameters:
    ///   - indexPath: Index path for the row
    ///   - searchActive: It checks if the search bar is active
    /// - Returns: A ZipCode object rather comes from the filtered or the main array.
    func cellForRowAt(_ indexPath: IndexPath, searchActive: Bool) -> ZipCode {
        if searchActive && filteredZipcodes.indices.contains(indexPath.row) {
            return filteredZipcodes[indexPath.row]
        } else {
            return zipcodes[indexPath.row]
        }
    }
    
    /// Did select row at index path
    /// - Parameters:
    ///   - indexPath: Index path for the row.
    ///   - searchActive: it checks if the search bar is active.
    ///   - completion: Returns the selected object.
    func didSelectRowAt(_ indexPath: IndexPath, searchActive: Bool, completion: (ZipCode) -> ()) {
        if searchActive && filteredZipcodes.indices.contains(indexPath.row) {
            completion(filteredZipcodes[indexPath.row])
        } else {
            completion(zipcodes[indexPath.row])
        }
    }
    
    /// Filters all the postal codes
    /// - Parameter text: Searcheable text
    func filterZipCodes(text: String) {
        filteredZipcodes = zipcodes.filter {
            text.isEmpty ? true : $0.zipCode.lowercased().replacingOccurrences(of: "-", with: " ").contains(text.lowercased()) || $0.zipCode.lowercased().contains(text.lowercased()) || $0.designation.lowercased().folding(options: .diacriticInsensitive, locale: .current).contains(text.lowercased())
        }
    }
}

// MARK: Fetch Data

extension ZipCpdeViewModel {
    
    /// Fetch the remote content only the first time the application starts, and later it checks rather the file exists or not locally.
    /// - Parameter completion: Triggers the follow-up action allowing the reload data on table view.
    func fetchContent(completion: @escaping () -> Void) {
        loading.value = true
        if FileManagerService.shared.fileExists(.zipcode) {
            fetchDataFromLocalDocument() {
                completion()
            }
        } else {
            fetchDataRemoteData() {
                completion()
            }
        }
    }
    
    /// Reads the local data stored on the device.
    /// - Parameter completion: Triggers the follow-up action allowing the reload data on table view.
    private func fetchDataFromLocalDocument(completion: @escaping () -> Void) {
        FileManagerService.shared.readFile(.zipcode, for: ZipCode.self) { [weak self] result in
            switch result {
            case .success(let content):
                DispatchQueue.main.async {
                    self?.zipcodes = content
                    self?.loading.value = false
                    completion()
                }

            case .failure(let error):
                self?.loading.value = false
                self?.alert.value = error.localizedDescription
            }
        }
    }
    
    /// Fetches the remote CSV file and writes it into a JSON file locally.
    /// - Parameter completion: Triggers the follow-up action allowing the reload data on table view.
    private func fetchDataRemoteData(completion: @escaping () -> Void) {
        CSVParserService.shared.parseCSVFrom(endpoint: .zipcodes) { [weak self] result in
            switch result {
            case .success(let content):
                self?.writeLocal(content: content) {
                    completion()
                }

            case .failure(let error):
                self?.loading.value = false
                self?.alert.value = error.localizedDescription
            }
        }
    }
    
    /// It creates a JSON file locally from the remote CSV data.
    /// - Parameters:
    ///   - content: The array of NSDictionary containing the CSV data.
    ///   - completion: Triggers the follow-up action allowing the reload data on table view.
    private func writeLocal(content: [NSDictionary], completion: @escaping () -> Void) {
        FileManagerService.shared.writeJSON(dictionary: content, fileName: .zipcode) { [weak self] error in
            if let error = error {
                self?.loading.value = false
                self?.alert.value = error.localizedDescription
                return
            }
            self?.fetchDataFromLocalDocument() {
                completion()
            }
        }
    }
}
