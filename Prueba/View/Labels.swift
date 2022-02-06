//
//  Labels.swift
//  Prueba
//
//  Created by Julio Enrique Barrón Castañeda on 05/02/22.
//

import Foundation
import UIKit

public var lblMessage: UILabel = {
    let label = UILabel()
    label.textColor = .red
    label.numberOfLines = 0
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()

public var lblProfile: UILabel = {
    let label = UILabel()
    label.textColor = .green
    label.numberOfLines = 0
    //label.textAlignment = .left
    label.text = "Profile"
    label.font = UIFont.boldSystemFont(ofSize: 24)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()

public var lblNameUsername: UILabel = {
    let label = UILabel()
    label.textColor = .green
    label.numberOfLines = 0
    //label.textAlignment = .left
    label.text = "Name\nUsername"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()

