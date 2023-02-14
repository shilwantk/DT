//
//  ListingViewModel.swift
//  D
//
//  Created by Kirti S on 2/10/23.
//

import Foundation

class ListingViewModel {
    
    var movieArray = [Movie]()
    var filteredMovieArray = [Movie]()
    
    var listingGenre = String()
    
    var isPaginating = false
    var pageNumber: Int = 1
    
    func fetchMovieDataFrom(pagination: Bool = false, completion: @escaping(Result<Bool, NetworkError>) -> Void) {
        
        if pagination {
            isPaginating = true
        }
        
        if pageNumber <= 2 {
            pageNumber = pageNumber + 1
        } else if pageNumber == 3 {
            return
        }
        
        let fileName = "Page" + String(pageNumber)
        
        APICaller().fetchDataFrom(fileName: fileName) { result in
            switch result {
            case .success((let genre, let movieData)):
                
                self.listingGenre = genre
                self.movieArray.append(contentsOf: movieData)
                
                completion(.success(true))
                if pagination {
                    self.isPaginating = false
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
