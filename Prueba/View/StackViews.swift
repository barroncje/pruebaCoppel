//
//  StackViews.swift
//  Prueba
//
//  Created by Julio Enrique Barrón Castañeda on 05/02/22.
//

import Foundation
import UIKit

public var stackViewSuperior: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
}()
