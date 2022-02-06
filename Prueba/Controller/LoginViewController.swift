//
//  ViewController.swift
//  Prueba
//
//  Created by Julio Enrique Barrón Castañeda on 05/02/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        btnLogin.addTarget(self, action: #selector(Login), for: .touchUpInside)
        
        addSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Functions
    func addSubviews() {
        view.addSubview(imgLogo)
        view.addSubview(txtUsername)
        view.addSubview(txtPassword)
        view.addSubview(btnLogin)
        view.addSubview(lblMessage)
        
        alignSubviews()
    }

    func alignSubviews() {
        txtUsername.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        txtUsername.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        txtUsername.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
        txtUsername.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        imgLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imgLogo.bottomAnchor.constraint(equalTo: txtUsername.topAnchor, constant: -32).isActive = true
        imgLogo.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imgLogo.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        txtPassword.topAnchor.constraint(equalTo: txtUsername.bottomAnchor, constant: 16).isActive = true
        txtPassword.leadingAnchor.constraint(equalTo: txtUsername.leadingAnchor).isActive = true
        txtPassword.trailingAnchor.constraint(equalTo: txtUsername.trailingAnchor).isActive = true
        txtPassword.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        btnLogin.topAnchor.constraint(equalTo: txtPassword.bottomAnchor, constant: 16).isActive = true
        btnLogin.leadingAnchor.constraint(equalTo: txtPassword.leadingAnchor).isActive = true
        btnLogin.trailingAnchor.constraint(equalTo: txtPassword.trailingAnchor).isActive = true
        btnLogin.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        lblMessage.topAnchor.constraint(equalTo: btnLogin.bottomAnchor, constant: 16).isActive = true
        lblMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        lblMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
    }
    
    @objc func Login() {
        let username = txtUsername.text
        let password = txtPassword.text
        
        if (username != "") && (password != "") {
            showSpinner(onView: view)
            getToken(username: username!, password: password!)
        } else {
            lblMessage.text = "Username y Password son requeridos."
        }
    }
    
    func getToken(username: String, password: String) {
        print("Solicitando el token")
        
        guard let url = URL(string: URL_REQUEST_TOKEN) else {return}
        print("url: \(url)")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let datos = data else {return}
            
            do {
                let dataRequestToken = try JSONDecoder().decode(RequestToken.self, from: datos)
                print("dataRequestToken: \(dataRequestToken)")
                
                let request_token = dataRequestToken.request_token
                print("request_token: \(request_token)")
                
                // Saving request_token
                userDefaults.set(request_token, forKey: "request_token")
                
                self.makeLogin(username: username, password: password, request_token: request_token!)
                
            } catch {
                removeSpinner()
                debugPrint("error: \(error)")
            }
        }.resume()
    }
    
    func makeLogin(username: String, password: String, request_token: String) {
        print("Haciendo login")
        
        guard let url = URL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(API_KEY)&username=\(username)&password=\(password)&request_token=\(request_token)") else {return}
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
                    print("hacer el push al view principal")
                    
                    self.getSessionId(request_token: request_token)
                } else {
                    print("mostrar el error")
                    
                    let status_message = dataRequest.status_message
                    print("status_message: \(status_message)")
                    
                    removeSpinner()
                    
                    DispatchQueue.main.async {
                        lblMessage.text = status_message
                    }
                }
            } catch {
                removeSpinner()
                debugPrint("error: \(error)")
            }
        }.resume()
    }
    
    func getSessionId(request_token: String) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/authentication/session/new?api_key=\(API_KEY)&request_token=\(request_token)") else {return}
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
                    print("guardo el session_id")
                    
                    let session_id = dataRequest.session_id
                    print("session_id: \(session_id)")
                    
                    // Saving request_token
                    userDefaults.set(session_id, forKey: "session_id")
                    
                    self.getAccountId(session_id: session_id!)
                    
                } else {
                    print("mostrar el error")
                }
            } catch {
                debugPrint("error: \(error)")
            }
        }.resume()
    }
    
    func getAccountId(session_id: String) {
        guard let url = URL(string: "https://api.themoviedb.org/3/account?api_key=\(API_KEY)&session_id=\(session_id)") else {return}
        print("url: \(url)")
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let datos = data else {return}
            
            do {
                let dataRequest = try JSONDecoder().decode(DataProfile.self, from: datos)
                print("dataRequest: \(dataRequest)")
                
                let id = dataRequest.id
                print("id: \(id!)")
                
                // Saving account_id
                userDefaults.set(id, forKey: "account_id")
               
                DispatchQueue.main.async {
                    lblMessage.text = ""
                    
                    removeSpinner()
                    
                    let principalViewController = PrincipalViewController()
                    self.navigationController?.pushViewController(principalViewController, animated: true)
                }
                
            } catch {
                debugPrint("error: \(error)")
            }
        }.resume()
    }
}

