//
//  MovieCell.swift
//  D
//
//  Created by Kirti S on 2/6/23.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    static let identifier = "MovieCell"
    
    private let movieImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieTitleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "TitilliumWeb-Light", size: 18)
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
            movieTitleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 24),
        ])
    }
    
    public func setUpSingleChatCellWith(data: Movie) {
        
        if let image = UIImage(named: data.posterImage) {
            movieImageView.image = image
        }
        else {
            movieImageView.image = UIImage(named: "placeholder_for_missing_posters")
        }
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
