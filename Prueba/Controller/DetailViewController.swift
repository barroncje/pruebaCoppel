//
//  DetailViewController.swift
//  Prueba
//
//  Created by Julio Enrique Barrón Castañeda on 06/02/22.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - Globals
    var media_id: Int?
    
    // MARK: - Controls
    public var imgFoto: UIImageView = {
        let imageView = UIImageView()
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
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var btnSetFavorite: UIButton = {
        let button = UIButton()
        button.setTitle("Set as Favorite", for: .normal)
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSetFavorite.addTarget(self, action: #selector(clickFavorite), for: .touchUpInside)

        addSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    // MARK: - Functions
    @objc func clickFavorite() {
        let text = btnSetFavorite.titleLabel?.text
        if (text == "Set as Favorite") {
            print("Set as Favorite")
            setAsFavorite(favorite: true)
        } else {
            print("Remove from Favorite")
            setAsFavorite(favorite: false)
        }
    }
    
    func setAsFavorite(favorite: Bool) {
        let session_id = userDefaults.string(forKey: "session_id")
        let account_id = userDefaults.string(forKey: "account_id")
        
        guard let url = URL(string: "https://api.themoviedb.org/3/account/\(account_id!.description)/favorite?api_key=\(API_KEY)&media_type=movie&media_id=\(self.media_id!)&favorite=\(favorite)&session_id=\(session_id!)") else {return}
        print("url: \(url)")
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let datos = data else {return}
            
            do {
                let dataRequest = try JSONDecoder().decode(RequestToken.self, from: datos)
                print("dataRequest: \(dataRequest)")
                
                let success = dataRequest.success
                print("success: \(success)")
                
                if (success!) {
                    if (favorite) {
                        DispatchQueue.main.async {
                            self.btnSetFavorite.setTitle("Remove from Favorite", for: .normal)
                            
                            // Leo el array
                            var array = userDefaults.array(forKey: "favorite_media_id") as? [Int] ?? [Int]()
                            print("array antes: \(array)")
                            // Agrego el item al array
                            array.append(self.media_id!)
                            // Guardo el array
                            userDefaults.set(array, forKey: "favorite_media_id")
                            print("array después: \(array)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.btnSetFavorite.setTitle("Set as Favorite", for: .normal)
                            
                            // Leo el array
                            var array = userDefaults.array(forKey: "favorite_media_id") as? [Int] ?? [Int]()
                            print("array antes: \(array)")
                            // Borro el item al array
                            if let index = array.firstIndex(of: self.media_id!) {
                                array.remove(at: index)
                            }
                            // Guardo el array
                            userDefaults.set(array, forKey: "favorite_media_id")
                            print("array después: \(array)")
                        }
                    }
                } else {
                    print("mostrar el error")
                }
            } catch {
                debugPrint("error: \(error)")
            }
        }.resume()
    }
    
    func addSubviews() {
        view.addSubview(imgFoto)
        view.addSubview(lblTitle)
        view.addSubview(lblReleaseDate)
        view.addSubview(lblVoteAverage)
        view.addSubview(imgStar)
        view.addSubview(lblOverview)
        view.addSubview(btnSetFavorite)
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
        
        media_id = popular.id!
        
        // Leyendo el array de ids de favoritos
        var array = userDefaults.array(forKey: "favorite_media_id") as? [Int] ?? [Int]()
        print("array leído: \(array)")
        
        if (array.contains(media_id!)) {
            btnSetFavorite.setTitle("Remove from Favorite", for: .normal)
        } else {
            btnSetFavorite.setTitle("Set as Favorite", for: .normal)
        }
        
        alignSubviews()
    }
    
    func alignSubviews() {
        imgFoto.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16).isActive = true
        imgFoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        imgFoto.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        imgFoto.heightAnchor.constraint(equalToConstant: 320).isActive = true
        
        lblTitle.topAnchor.constraint(equalTo: imgFoto.bottomAnchor,
                                              constant: 8).isActive = true
        lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: 16).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        lblReleaseDate.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 8).isActive = true
        lblReleaseDate.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor).isActive = true
        
        lblVoteAverage.topAnchor.constraint(equalTo: lblReleaseDate.topAnchor).isActive = true
        lblVoteAverage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        imgStar.centerYAnchor.constraint(equalTo: lblVoteAverage.centerYAnchor).isActive = true
        imgStar.trailingAnchor.constraint(equalTo: lblVoteAverage.leadingAnchor, constant: -4).isActive = true
        imgStar.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imgStar.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        lblOverview.topAnchor.constraint(equalTo: lblReleaseDate.bottomAnchor, constant: 8).isActive = true
        lblOverview.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor).isActive = true
        lblOverview.trailingAnchor.constraint(equalTo: lblVoteAverage.trailingAnchor).isActive = true
        
        btnSetFavorite.topAnchor.constraint(equalTo: lblOverview.bottomAnchor, constant: 16).isActive = true
        btnSetFavorite.leadingAnchor.constraint(equalTo: lblOverview.leadingAnchor).isActive = true
        btnSetFavorite.trailingAnchor.constraint(equalTo: lblOverview.trailingAnchor).isActive = true
        btnSetFavorite.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}
