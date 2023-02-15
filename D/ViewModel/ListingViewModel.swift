//
//  ListingViewModel.swift
//  D
//
//  Created by Kirti S on 2/10/23.
//

import Foundation

class ListingViewModel {
    
    /// An array of type Movie to hold all Movie listings from the API call
    var movieArray = [Movie]()
    
    /// An array of type Movie to hold all filtered Movie listings when the user searches for a movie
    var filteredMovieArray = [Movie]()
    
    /// A string value denoting the title of the listing page based on the field "title" recieved from the API call
    var listingGenre = String()
    
    /// Boolean indicating if a paginating fetch request to the API call is in progress
    var isPaginating = false
    
    /// Integer value to paginate through all 3 pages of the JSON files.
    ///  Default value set to 1 to start fetching data from the first page
    var pageNumber: Int = 1
    
    
    /// Function to fetch movie data that takes  a boolean indicating pagination and returns a boolean value of true in case of successful fetch or a Network Error type in case of a failure.
    /// - Parameters:
    ///   - pagination: Boolean, has a defualt value of false. When set to true, is used to indicate if the pagination is in progress.
    ///   - completion: A callback that returns a Result type, of Boolean indicating successful data fetching and a Network error in case of a failure.
    func fetchMovieDataFrom(pagination: Bool = false, completion: @escaping(Result<Bool, NetworkError>) -> Void) {

        /// if pagination is set to true, increment the count of page number by 1 and set isPaginating to true to prevent multiple pagination requests
        if pagination {
            isPaginating = true
            if pageNumber <= 2 {
                pageNumber = pageNumber + 1
            } else if pageNumber == 3 {
                /// Returns the function, stops after fetching all data from the files.
                return
            }
        }
        
        /// Generates a filename of format  "Listing(\pageNumber)" to fetch from a specific fle in the Data folder
        let fileName = "Listing" + String(pageNumber)
        
        /// Initilaize an instance of APICaller class to call the fetchDatafunction that takes a string filename as a paramater.
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
