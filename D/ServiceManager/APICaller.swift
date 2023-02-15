//
//  JSONParser.swift
//  D
//
//  Created by Kirti S on 2/10/23.
//

import Foundation

enum NetworkError : Error {
    case InvalidFileName
    case InvalidFilePath
    case UnsuccessfulDecoding
    case NilDataFound
}

class APICaller {
    
    /// Function to fetch data from the specified filename.json file
    /// - Parameters:
    ///   - fileName: String represetning the json file name to fetch and parse data from
    ///   - completion: A callback that returns a resuly type of an array of Movie objects and a string denoting the genre of the listing, if successful and a Network Error error if unsuccessful
    func fetchDataFrom(fileName:String, completion: @escaping (Result<(String,[Movie]), NetworkError>) -> Void) {
        
        /// Check for a valid filename in resources
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            completion(.failure(.InvalidFileName))
            return
        }
        
        /// Check for a valid filepath in resources
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            completion(.failure(.InvalidFilePath))
            return
        }
        
        do {
            let jsonData = try? JSONDecoder().decode(PageData.self, from: data)
            
            guard let data = jsonData else {
                completion(.failure(.NilDataFound))
                return
            }
            
            let movieArray = data.page.contentItems.content
            completion(.success((data.page.title, movieArray)))
        } catch {
            completion(.failure(.UnsuccessfulDecoding))
        }
    }
}
