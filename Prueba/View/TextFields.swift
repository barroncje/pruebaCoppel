//
//  TextFields.swift
//  Prueba
//
//  Created by Julio Enrique Barrón Castañeda on 05/02/22.
//

import Foundation
import UIKit

public var txtUsername: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Username"
    textField.text = "barroncje"
    textField.autocapitalizationType = .none
    textField.backgroundColor = .white
    textField.keyboardType = .emailAddress
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
}()

public var txtPassword: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Password"
    textField.text = "miPa$$32"
    textField.autocapitalizationType = .none
    textField.backgroundColor = .white
    textField.isSecureTextEntry = true
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
}()
