//
//  LoadingViewController.swift
//  Il Giardino
//
//  Created by Christian Luarca on 5/16/19.
//  Copyright © 2019 Surilis Labs. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    var loading_circle = UIActivityIndicatorView(style: .whiteLarge)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        loading_circle.translatesAutoresizingMaskIntoConstraints = false
        loading_circle.startAnimating()
        view.addSubview(loading_circle)
        
        loading_circle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loading_circle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
