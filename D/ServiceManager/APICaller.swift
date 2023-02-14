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

    func fetchDataFrom(fileName:String, completion: @escaping (Result<(String,[Movie]), NetworkError>) -> Void) {
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            completion(.failure(.InvalidFileName))
            return
        }
        
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
