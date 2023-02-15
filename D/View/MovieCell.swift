//
//  MovieCell.swift
//  D
//
//  Created by Kirti S on 2/6/23.
//

import UIKit

/// Class for the custom collection view cell that lists an object of the Movie type
class MovieCell: UICollectionViewCell {
    
    /// String identifoier for reusing the collction view cells
    static let identifier = "MovieCell"
    
    /// Image view to display the movie poster
    private let movieImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Label to display the name of the movie
    /// Using a default value for label font as mentioned in the official Apple documentation
    /// https://developer.apple.com/documentation/uikit/uilabel/1620532-font
    private let movieTitleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "TitilliumWeb-Light", size: 17)
        titleLabel.textColor = .white
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.4
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieTitleLabel)
        
        NSLayoutConstraint.activate([
            
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            movieImageView.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 20),
            movieImageView.heightAnchor.constraint(equalToConstant: contentView.bounds.height - 40),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            movieTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieTitleLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 20),
            movieTitleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor),
        ])
    }
    
    /// Sets up a collection view cell with a Movie object
    /// - Parameter data: An object of type Movie, that represents a single movie listing with a name and a poster image.
    public func setUpSingleChatCellWith(data: Movie) {
        
        /// Looks for an image file named the same as the posterImage value in data
        /// if the image file with the same name is found, sets the cell image to that image
        /// if the image file with the same name is not found, sets the cell image to the defualt missing poster placeholder image
        if let image = UIImage(named: data.posterImage) {
            movieImageView.image = image
        }
        else {
            movieImageView.image = UIImage(named: "placeholder_for_missing_posters")
        }
        
        /// sets the movie title label text to the movie name receieved from data
        movieTitleLabel.text = data.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
    }
}
