//
//  PrincipalViewController.swift
//  Prueba
//
//  Created by Julio Enrique Barrón Castañeda on 05/02/22.
//

import UIKit

class PrincipalViewController: UIViewController {
    // MARK: - Globals
    var arrayPopular: [ResultPopular] = [ResultPopular]()
    
    private lazy var collectionViewPopular: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
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

        view.backgroundColor = .darkGray
        
        btnPopular.addTarget(self, action: #selector(showPopular), for: .touchUpInside)
        btnTopRated.addTarget(self, action: #selector(showTopRated), for: .touchUpInside)
        btnOnTV.addTarget(self, action: #selector(showOnTV), for: .touchUpInside)
        btnAiringToday.addTarget(self, action: #selector(showAiringToday), for: .touchUpInside)
        
        addSubviews()
        
        getPopularData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        navigationItem.title = "TV Shows"
        navigationController?.navigationBar.backgroundColor = .darkGray
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(showOptions))
    }
    
    // MARK: - Functions
    func getPopularData() {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(API_KEY)&language=en-US&page=1") else {return}
        print("url: \(url)")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let datos = data else {return}
            
            do {
                let dataRequest = try JSONDecoder().decode(PopularData.self, from: datos)
                print("dataRequest: \(dataRequest)")
                
                self.arrayPopular = dataRequest.results!
                
                for item in self.arrayPopular {
                    print("\nitem: \(item)")
                }
            } catch {
                debugPrint("error: \(error)")
            }
        }.resume()
    }
    
    @objc func showOptions() {
        print("mostrar las opciones")
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction: UIAlertAction = UIAlertAction(title: "View Profile", style: .default) { action -> Void in
            print("View Profile")
            
            let profileViewController = ProfileViewController()
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Log out", style: .destructive) { action -> Void in
            print("Log out")
            
            self.logOut()
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }

        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)

        actionSheetController.popoverPresentationController?.sourceView = view
        present(actionSheetController, animated: true)
    }
    
    func logOut() {
        let alert = UIAlertController(title: "Log out", message: "¿Estás seguro que quieres cerrar tu sesión?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Sí", style: .default, handler: { (action: UIAlertAction!) in
            self.salir()
        }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
              
        }))

        present(alert, animated: true, completion: nil)
    }
    
    func salir() {
        let session_id = userDefaults.string(forKey: "session_id")
        
        let url = URL(string: "https://api.themoviedb.org/3/authentication/session?api_key=\(API_KEY)&session_id=\(session_id!)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let datos = data else {return}
            
            do {
                let dataRequest = try JSONDecoder().decode(RequestToken.self, from: datos)
                print("dataRequest: \(dataRequest)")
                
                let success = dataRequest.success
                print("success: \(success)")
                
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } catch {
                debugPrint("error: \(error)")
            }
        }.resume()
    }
    
    @objc func showPopular() {
        print("Popular")
        btnPopular.backgroundColor = .darkGray
        btnTopRated.backgroundColor = .clear
        btnOnTV.backgroundColor = .clear
        btnAiringToday.backgroundColor = .clear
    }
    
    @objc func showTopRated() {
        print("Top Rated")
        btnPopular.backgroundColor = .clear
        btnTopRated.backgroundColor = .darkGray
        btnOnTV.backgroundColor = .clear
        btnAiringToday.backgroundColor = .clear
    }
    
    @objc func showOnTV() {
        print("On TV")
        btnPopular.backgroundColor = .clear
        btnTopRated.backgroundColor = .clear
        btnOnTV.backgroundColor = .darkGray
        btnAiringToday.backgroundColor = .clear
    }
    
    @objc func showAiringToday() {
        print("Airing Today")
        btnPopular.backgroundColor = .clear
        btnTopRated.backgroundColor = .clear
        btnOnTV.backgroundColor = .clear
        btnAiringToday.backgroundColor = .darkGray
    }
    
    func addSubviews() {
        view.addSubview(viewFondo)
        viewFondo.addSubview(stackViewSuperior)
        stackViewSuperior.addArrangedSubview(btnPopular)
        stackViewSuperior.addArrangedSubview(btnTopRated)
        stackViewSuperior.addArrangedSubview(btnOnTV)
        stackViewSuperior.addArrangedSubview(btnAiringToday)
        
        view.addSubview(collectionViewPopular)
        
        alignSubviews()
    }
    
    func alignSubviews() {
        viewFondo.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8).isActive = true
        viewFondo.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewFondo.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewFondo.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        stackViewSuperior.topAnchor.constraint(equalTo: viewFondo.topAnchor, constant: 16).isActive = true
        stackViewSuperior.leadingAnchor.constraint(equalTo: viewFondo.leadingAnchor, constant: 16).isActive = true
        stackViewSuperior.trailingAnchor.constraint(equalTo: viewFondo.trailingAnchor, constant: -16).isActive = true
        stackViewSuperior.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        collectionViewPopular.topAnchor.constraint(equalTo: stackViewSuperior.bottomAnchor, constant: 16).isActive = true
        collectionViewPopular.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        collectionViewPopular.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        collectionViewPopular.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}

extension PrincipalViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPopular.count
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
            cell.configure(popular: arrayPopular[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.configure(popular: arrayPopular[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
