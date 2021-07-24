//
//  FormViewModel.swift
//  WTest
//
//  Created by Leonardo Bilia on 23/07/21.
//

import Foundation

final class FormViewModel {
    
    private(set) var quality = ["Mau", "Satisfatório", "Bom", "Muito Bom", "Excelente"]

    // MARK: - Methods
    
    /// Number of components for the picker.
    /// - Returns: Number of components.
    func numberOfComponents() -> Int {
        return 1
    }
    
    /// Number of rows in the picker component.
    /// - Returns: Number of rows for each component.
    func numberOfRowsInComponent(_ component: Int) -> Int {
        return quality.count
    }
    
    /// Title for picker row.
    /// - Parameter row: The row where to set the title.
    /// - Returns: The title for the row.
    func titleForRow(_ row: Int) -> String? {
        return quality[row]
    }
    
    /// Did select picker row.
    /// - Parameters:
    ///   - row: Selected picker row.
    ///   - completion: Returns the selected item.
    func didSelectRow(_ row: Int, completion: (String) -> ()) {
        completion(quality[row])
    }
}

