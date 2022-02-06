//
//  PopularCollectionViewCell.swift
//  Prueba
//
//  Created by Julio Enrique Barrón Castañeda on 06/02/22.
//

import UIKit

class PopularCollectionViewCell: UICollectionViewCell {
    static let cellName: String = "celdaPopular"
    
    public var imgFoto: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public var lblTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .green
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var lblReleaseDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var lblVoteAverage: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var imgStar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public var lblOverview: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    func configure(popular: ResultPopular) {
        let fullPathImage = "https://image.tmdb.org/t/p/original\(popular.poster_path!)"
        print("fullPathImage: \(fullPathImage)")
        
        let urlImage = URL(string: fullPathImage)
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: urlImage!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self!.imgFoto.image = image
                        
                        self!.imgFoto.layer.masksToBounds = false
                        self!.imgFoto.layer.cornerRadius = 10
                        self!.imgFoto.clipsToBounds = true
                    }
                }
            }
        }
        
        lblTitle.text = popular.title
        lblReleaseDate.text = popular.release_date
        lblVoteAverage.text = popular.vote_average?.description
        lblOverview.text = popular.overview
    }
    
    private func setupCell() {
        
        layer.backgroundColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        contentView.addSubview(imgFoto)
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblReleaseDate)
        contentView.addSubview(lblVoteAverage)
        contentView.addSubview(imgStar)
        contentView.addSubview(lblOverview)
        
        imgFoto.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imgFoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imgFoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imgFoto.heightAnchor.constraint(equalToConstant: (contentView.bounds.height / 2) + 16).isActive = true
        
        lblTitle.topAnchor.constraint(equalTo: imgFoto.bottomAnchor,
                                              constant: 8).isActive = true
        lblTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: 8).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        lblReleaseDate.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 8).isActive = true
        lblReleaseDate.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor).isActive = true
        
        lblVoteAverage.topAnchor.constraint(equalTo: lblReleaseDate.topAnchor).isActive = true
        lblVoteAverage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        imgStar.centerYAnchor.constraint(equalTo: lblVoteAverage.centerYAnchor).isActive = true
        imgStar.trailingAnchor.constraint(equalTo: lblVoteAverage.leadingAnchor, constant: -4).isActive = true
        imgStar.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imgStar.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        lblOverview.topAnchor.constraint(equalTo: lblReleaseDate.bottomAnchor, constant: 8).isActive = true
        lblOverview.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor).isActive = true
        lblOverview.trailingAnchor.constraint(equalTo: lblVoteAverage.trailingAnchor).isActive = true
    }
}
