//
//  UIViewController+Extension.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/21/21.
//

import UIKit

extension UIViewController {
    func prepareNavigationBar() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "barLogo"))
    }
    
    func showCustomMessageAlert(message: String, title: String = "", completion: @escaping () -> ()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            completion()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
