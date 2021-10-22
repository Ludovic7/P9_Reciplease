//
//  Alert.swift
//  Reciplease
//
//  Created by Ludovic DANGLOT on 14/10/2021.
//

import UIKit

extension UIViewController {
    func didAlert(message: String) {
        let alertVC = UIAlertController(title: "Erreur!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
}
