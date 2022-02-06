//
//  Views.swift
//  Prueba
//
//  Created by Julio Enrique Barrón Castañeda on 05/02/22.
//

import Foundation
import UIKit

public var viewFondo: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}()

var vSpinner : UIView?
func showSpinner(onView : UIView) {
    let spinnerView = UIView.init(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.25)
    let ai = UIActivityIndicatorView.init(style: .large)
    ai.startAnimating()
    ai.center = spinnerView.center
    
    DispatchQueue.main.async {
        spinnerView.addSubview(ai)
        onView.addSubview(spinnerView)
    }
    
    vSpinner = spinnerView
}

func removeSpinner() {
    DispatchQueue.main.async {
        vSpinner?.removeFromSuperview()
        vSpinner = nil
    }
}
