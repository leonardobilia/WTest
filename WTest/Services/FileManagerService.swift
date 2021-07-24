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
    
    /// Check rather exists or not a specific file in the documents directory of the device.
    /// - Parameter file: Filename from enum
    /// - Returns: Boolean indicating if the file exists
    func fileExists(_ file: LocalFileName) -> Bool {
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(file.rawValue)
        return FileManager.default.fileExists(atPath: destinationUrl.path)
    }
    
    /// Read files from the document directory of the device.
    /// - Parameters:
    ///   - file: Filename from enum
    ///   - model: Type of the file's content
    ///   - completion: It sends the data or the error at the end of the data decoding task.
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
    
    /// Create a JSON file and write it to the document directory of the device for local access.
    /// - Parameters:
    ///   - dictionary: Content to be converted to JSON.
    ///   - fileName: The file name for the newly created file.
    ///   - completion: Indicates the and of the process and if there is an error in the process.
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
