//
//  ProfileViewController.swift
//  Prueba
//
//  Created by Julio Enrique Barrón Castañeda on 06/02/22.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Controls
    var arrayFavorite: [ResultPopular] = [ResultPopular]()
    
    private lazy var collectionViewFavorite: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 2) - 32,
                                                    height: (UIScreen.main.bounds.height / 2) - 96)
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.minimumLineSpacing = 32
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(PopularCollectionViewCell.self,
                                 forCellWithReuseIdentifier: PopularCollectionViewCell.cellName)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = true
        
        collectionView.delegate = self
        collectionView.dataSource = self

        return collectionView
    }()

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        addSubviews()
        
        getProfile()
        
        getFavoriteData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        getFavoriteData()
    }
    
    // MARK: - Functions
    func getFavoriteData() {
        let session_id = userDefaults.string(forKey: "session_id")
        let account_id = userDefaults.string(forKey: "account_id")
        
        guard let url = URL(string: "https://api.themoviedb.org/3/account/\(account_id!)/favorite/movies?api_key=\(API_KEY)&session_id=\(session_id!)&language=en-US&sort_by=created_at.asc&page=1") else {return}
        print("url: \(url)")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let datos = data else {return}
            
            do {
                let dataRequest = try JSONDecoder().decode(PopularData.self, from: datos)
                print("dataRequest: \(dataRequest)")
                
                self.arrayFavorite = dataRequest.results!
                
                for item in self.arrayFavorite {
                    print("\nitem favorite: \(item)")
                    
                    DispatchQueue.main.async {
                        self.collectionViewFavorite.reloadData()
                    }
                    
                }
            } catch {
                debugPrint("error: \(error)")
            }
        }.resume()
    }
    
    func getProfile() {
        print("getProfile")
        
        let session_id = userDefaults.string(forKey: "session_id")

        guard let url = URL(string: "https://api.themoviedb.org/3/account?api_key=\(API_KEY)&session_id=\(session_id!)") else {return}
        print("url: \(url)")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let datos = data else {return}
            
            do {
                let dataRequest = try JSONDecoder().decode(DataProfile.self, from: datos)
                print("dataRequest: \(dataRequest)")
                
                let avatar_path = dataRequest.avatar?.tmdb.avatar_path ?? ""
                print("avatar_path: \(avatar_path)")
                
                if (avatar_path != "") {
                    let fullPathImage = "https://image.tmdb.org/t/p/original\(avatar_path)"
                    print("fullPathImage: \(fullPathImage)")
                    
                    let urlImage = URL(string: fullPathImage)
                    
                    DispatchQueue.global().async { [weak self] in
                        if let data = try? Data(contentsOf: urlImage!) {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    imgProfile.image = image
                                    
                                    imgProfile.layer.borderWidth = 2
                                    imgProfile.layer.masksToBounds = false
                                    imgProfile.layer.borderColor = UIColor.white.cgColor
                                    imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2
                                    imgProfile.clipsToBounds = true
                                }
                            }
                        }
                    }
                }
                
                let name = dataRequest.name ?? ""
                print("name: \(name)")
               
                let username = dataRequest.username
                print("username: \(username)")
                
                DispatchQueue.main.async {
                    lblNameUsername.text = name + "\n@" + username!
                }
            } catch {
                debugPrint("error: \(error)")
            }
        }.resume()
    }
    
    func addSubviews() {
        view.addSubview(lblProfile)
        view.addSubview(imgProfile)
        view.addSubview(lblNameUsername)
        view.addSubview(collectionViewFavorite)
        
        alignSubviews()
    }
    
    func alignSubviews() {
        lblProfile.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16).isActive = true
        lblProfile.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        imgProfile.topAnchor.constraint(equalTo: lblProfile.bottomAnchor, constant: 32).isActive = true
        imgProfile.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 32).isActive = true
        imgProfile.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imgProfile.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        lblNameUsername.centerYAnchor.constraint(equalTo: imgProfile.centerYAnchor).isActive = true
        lblNameUsername.leadingAnchor.constraint(equalTo: imgProfile.trailingAnchor, constant: 32).isActive = true
        
        collectionViewFavorite.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        collectionViewFavorite.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        collectionViewFavorite.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        collectionViewFavorite.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height / 2) - 96).isActive = true
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(arrayFavorite.count)
        return arrayFavorite.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCollectionViewCell.cellName,
                                                      for: indexPath)
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? PopularCollectionViewCell {
            cell.configure(popular: arrayFavorite[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.configure(popular: arrayFavorite[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
