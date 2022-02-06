//
//  Buttons.swift
//  Prueba
//
//  Created by Julio Enrique Barrón Castañeda on 05/02/22.
//

import Foundation
import UIKit

public var btnLogin: UIButton = {
    let button = UIButton()
    button.setTitle("Log in", for: .normal)
    button.backgroundColor = .darkGray
    button.setTitleColor(.white, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}()

public var btnPopular: UIButton = {
    let button = UIButton()
    button.setTitle("Popular", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    button.backgroundColor = .darkGray
    button.setTitleColor(.white, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}()

public var btnTopRated: UIButton = {
    let button = UIButton()
    button.setTitle("Top Rated", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}()

public var btnOnTV: UIButton = {
    let button = UIButton()
    button.setTitle("On TV", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}()

public var btnAiringToday: UIButton = {
    let button = UIButton()
    button.setTitle("Airing Today", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
}()
