//
//  ZipCpdeViewModel.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import Foundation

class ZipCpdeViewModel {

    private var zipcodes: [ZipCode] = []
    private var filteredZipcodes: [ZipCode] = []
    
    var loading: Bindable<Bool> = Bindable(false)
    var alert: Bindable<String?> = Bindable(nil)
    
    // MARK: - Methods
    
    func numberOfRows(searchActive: Bool) -> Int {
        return searchActive ? filteredZipcodes.count : zipcodes.count
    }
    
    func cellForRowAt(_ indexPath: IndexPath, searchActive: Bool) -> ZipCode {
        if searchActive && filteredZipcodes.indices.contains(indexPath.row) {
            return filteredZipcodes[indexPath.row]
        } else {
            return zipcodes[indexPath.row]
        }
    }
    
    func filterZipCodes(text: String) {
        filteredZipcodes = zipcodes.filter {
            text.isEmpty ? true : $0.zipCode.lowercased().replacingOccurrences(of: "-", with: " ").contains(text.lowercased()) || $0.zipCode.lowercased().contains(text.lowercased()) || $0.designation.lowercased().folding(options: .diacriticInsensitive, locale: .current).contains(text.lowercased())
        }
    }
}

// MARK: Fetch Data

extension ZipCpdeViewModel {
    
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
