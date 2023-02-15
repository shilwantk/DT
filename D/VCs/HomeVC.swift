//
//  HomeVC.swift
//  D
//
//  Created by Kirti S on 2/6/23.
//

import UIKit

class HomeVC: UIViewController {
    
    /// View at the top of the screenl to display the title of the page and the search bar
    private let topView : UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "nav_bar")!)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Back  image view
    private let backButton : UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "backButton")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Label displayed at the top of the page to denote the genre of the listing shown currently
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "TitilliumWeb-Light", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Search image view to initialize and display a search bar
    private let searchButton : UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    /// Collection view of type MovieCell to display movie listings of type Movie
    private let myCollectionView : UICollectionView = {
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .black
        cv.alwaysBounceVertical = true
        cv.contentInsetAdjustmentBehavior = .always
        cv.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    /// Refenence to the view model of type ListingViewModel
    private let viewModel = ListingViewModel()
    
    /// Boolean to track if search functionality is being used
    private var isSearching = false
    
    /// overriding the preferred status bar style to display a light status bar in accordance with a dark view controllert
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// set up collection view delegate and data source
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        /// Call to fetch movie data that returns a success or a failure with an error value
        self.viewModel.fetchMovieDataFrom { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.myCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpUI()
    }
    
    override func viewDidLayoutSubviews() {
        
        topView.addSubview(backButton)
        topView.addSubview(titleLabel)
        topView.addSubview(searchButton)
        
        view.addSubview(myCollectionView)
        view.addSubview(topView)
        
        NSLayoutConstraint.activate([
            
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            topView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            topView.heightAnchor.constraint(equalToConstant:50),
            
            backButton.widthAnchor.constraint(equalToConstant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 20),
            backButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            searchButton.widthAnchor.constraint(equalToConstant: 20),
            searchButton.heightAnchor.constraint(equalToConstant: 20),
            searchButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -20),
            searchButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            myCollectionView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8),
            myCollectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            myCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setUpUI() {
        view.backgroundColor = .black
        
        /// Setting the title label text of the page
        titleLabel.text = self.viewModel.listingGenre
        
        /// Adding agesture recognizer for the search image view to initialize and display a search bar
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchButtonTapped))
        searchButton.addGestureRecognizer(searchTap)
    }
    
    @objc func searchButtonTapped(searchBarbuttonItem barButtonItem: UIBarButtonItem) {
        
        //setting up and presenting a search controller on search image view tap
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search a movie"
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    // TODO: In case of a navigation controller, set up the back button functionality
    @objc func backButtonTapped(barButtonItem: UIBarButtonItem) {
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        /// returns a count of the fitered array data if the search bar is being edited
        if isSearching {
            return self.viewModel.filteredMovieArray.count
        } else {
            return self.viewModel.movieArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        
        /// call to set up the collection view cell based on the whether the seatch functionality is being used or not
        if isSearching {
            myCell.setUpSingleChatCellWith(data: viewModel.filteredMovieArray[indexPath.row])
        } else {
            myCell.setUpSingleChatCellWith(data: viewModel.movieArray[indexPath.row])
        }
        
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        /// using a default value for line spacing as mentioned in the official Apple documentation
        /// https://developer.apple.com/documentation/uikit/uicollectionviewflowlayout/1617717-minimumlinespacing
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/3) - 3, height: (view.frame.size.width/2) - 3)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //when the end of the current collection view is reached, paginate for more data
        if(self.myCollectionView.contentOffset.y >= (self.myCollectionView.contentSize.height - self.myCollectionView.bounds.size.height)) {
            
            /// Check to see if a fetch request is not already in progress
            if !self.viewModel.isPaginating {
                self.viewModel.fetchMovieDataFrom(pagination: true ) { [weak self] result in
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            self?.myCollectionView.reloadData()
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

extension HomeVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let query = searchController.searchBar.text else { return }
        
        self.viewModel.filteredMovieArray = self.viewModel.movieArray.filter({$0.name.lowercased().prefix(query.count) == query.lowercased()})
        
        DispatchQueue.main.async {
            self.myCollectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        DispatchQueue.main.async {
            self.myCollectionView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        DispatchQueue.main.async {
            self.myCollectionView.reloadData()
        }
    }
}

