//
//  LicenseVC.swift
//  Timer
//
//  Created by sunggwang_park on 2021/10/05.
//

import Foundation
import UIKit

class LicenseVC : UIViewController {
    
    let scroll = UIScrollView()
    let licenseDetail = UILabel()
    let licenseName = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    
}

// MARK: - Functions
extension LicenseVC {
    func setupUI() {
        view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scroll.widthAnchor.constraint(equalTo: view.widthAnchor),
            scroll.heightAnchor.constraint(equalTo: view.heightAnchor),
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        scroll.addSubview(licenseDetail)
        scroll.addSubview(licenseName)
        
        licenseName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            licenseName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            licenseName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
        
        licenseName.text = "Sectioned Slider"
        
        licenseDetail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            licenseDetail.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            licenseDetail.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            licenseDetail.topAnchor.constraint(equalTo: licenseName.bottomAnchor, constant: 10)
        ])
        licenseDetail.font = UIFont.systemFont(ofSize: 12)
        licenseDetail.numberOfLines = 0
        licenseDetail.text = """
MIT License

Copyright (c) 2017 leocardz.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""
    }
}

// MARK: - Objc Functions
extension LicenseVC {
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
}
