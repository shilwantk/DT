//
//  ViewController.swift
//  D
//
//  Created by Kirti S on 2/6/23.
//

import UIKit

class HomeVC: UIViewController {
    
    private let topView : UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "nav_bar")!)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton : UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "backButton")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "TitilliumWeb-Light", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchButton : UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
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
    
    private let viewModel = ListingViewModel()
    
    //variable to track if search bar is being edited
    private var isSearching = false
    
    //light status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
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
            
            myCollectionView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 36),
            myCollectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            myCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
    private func setUpUI() {
        view.backgroundColor = .black
        titleLabel.text = self.viewModel.listingGenre
        
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(searchButtonTapped))
        searchButton.addGestureRecognizer(searchTap)
    }
    
    @objc func searchButtonTapped(searchBarbuttonItem barButtonItem: UIBarButtonItem) {
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
    
    @objc func backButtonTapped(barButtonItem: UIBarButtonItem) {
        //add functionality here
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return self.viewModel.filteredMovieArray.count
        } else {
            return self.viewModel.movieArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        if isSearching {
            myCell.setUpSingleChatCellWith(data: viewModel.filteredMovieArray[indexPath.row])
        } else {
            myCell.setUpSingleChatCellWith(data: viewModel.movieArray[indexPath.row])
        }
        
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/3) - 3, height: (view.frame.size.width/2) - 3)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //when the end of the current collection view is reached, paginate fr more data
        if(self.myCollectionView.contentOffset.y >= (self.myCollectionView.contentSize.height - self.myCollectionView.bounds.size.height)) {
            
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

