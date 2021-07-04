//
//  UIViewController+Alert.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/1/21.
//

import UIKit

extension UIViewController {
    func showAlertWith(_ message: String, title: String, completion: Completion) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in 
            completion?()
        }))
        self.present(ac, animated: true, completion: nil)
    }
}
