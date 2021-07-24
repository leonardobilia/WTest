//
//  CSVParserService.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import Foundation

struct CSVParserService {
    static var shared = CSVParserService()
    
    /// Reads and map the CSV file from the server.
    /// - Parameters:
    ///   - endpoint: All the available URLs come from the enum Endpoint.
    ///   - completion: It sends the CSV converted to an NSDictionary or the error at the end of the process.
    func parseCSVFrom(endpoint: Endpoint, completion: @escaping (Result<[NSDictionary], Error>) -> Void) {
        guard let url = endpoint.url else { return }
        
        do {
            let content = try String(contentsOf: url)
            let data = JSONFromCSV(content: content)
            
            var result = [NSDictionary]()
            
            for item in data {
                if let designation = item.value(forKey: "desig_postal") as? String,
                let zipcode = item.value(forKey: "num_cod_postal") as? String,
                let extraCode = item.value(forKey: "ext_cod_postal") as? String {
                    result.append(NSDictionary(dictionary: ["info" : "\(zipcode)-\(extraCode)  \(designation.capitalized)"]))
                }
            }
            completion(.success(result))
            
        } catch{
            completion(.failure(error))
        }
    }
    
    /// It converts the CSV content to an NSDictionary.
    /// - Parameter content: A string representing the CSV content.
    /// - Returns: An array of NSDictionary.
    private func JSONFromCSV(content: String) -> [NSDictionary] {
        let lines = content.components(separatedBy: "\n")
        let columns = lines[0].components(separatedBy: ",")
        var lineIndex = 1
        let columnCount = columns.count
        var result = [NSDictionary]()
        
        for line in lines[lineIndex ..< lines.count] {
            let values = line.components(separatedBy: ",")
            
            if values.count != columnCount {
                print("WARNING: header has \(columnCount) columns but line \(lineIndex) has \(values.count) columns.")
            } else {
                result.append(NSDictionary(objects: values, forKeys: columns as [NSCopying]))
            }
            lineIndex = lineIndex + 1
        }
        return result
    }
}
