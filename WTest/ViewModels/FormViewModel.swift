//
//  FormViewModel.swift
//  WTest
//
//  Created by Leonardo Bilia on 23/07/21.
//

import Foundation

class FormViewModel {
    
    private(set) var quality = ["Mau", "Satisfatório", "Bom", "Muito Bom", "Excelente"]

    // MARK: - Methods
    
    func numberOfComponents() -> Int {
        return 1
    }
    
    func numberOfRowsInComponent(_ component: Int) -> Int {
        return quality.count
    }
    
    func titleForRow(_ row: Int) -> String? {
        return quality[row]
    }
    
    func didSelectRow(_ row: Int, completion: (String) -> ()) {
        completion(quality[row])
    }
}

