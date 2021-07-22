//
//  FileManagerService.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import Foundation

struct FileManagerService {
    static var shared = FileManagerService()
    
    enum LocalFileName: String {
        case zipcode = "ZipCodes.json"
    }
    
    func fileExists(_ file: LocalFileName) -> Bool {
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(file.rawValue)
        return FileManager.default.fileExists(atPath: destinationUrl.path)
    }
    
    func readFile<T: Decodable>(_ file: LocalFileName, for model: T.Type, completion: @escaping (Result<[T], Error>) -> Void) {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(file.rawValue)
            
            let data = try Data(contentsOf: fileURL)
            let zipCode = try JSONDecoder().decode([T].self, from: data)
            completion(.success(zipCode))
        } catch {
            completion(.failure(error))
        }
    }
    
    func writeJSON(dictionary: [NSDictionary], fileName: LocalFileName, completion: @escaping (Error?) -> Void) {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(fileName.rawValue)
            
            try JSONSerialization.data(withJSONObject: dictionary)
                .write(to: fileURL)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
