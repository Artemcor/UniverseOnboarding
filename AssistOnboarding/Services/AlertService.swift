//
//  AlertService.swift
//  AssistOnboarding
//
//  Created by Artemcore on 21.05.2023.
//

import UIKit

class AlertService {
    
    static func restoreAlert(okButtonHandler: @escaping () -> ()) -> UIViewController {
        let alert = UIAlertController(title: "Error", message: "Oops... No purchases to restore.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
            okButtonHandler()
        })
        return alert
    }
    
    static func crossAlert(okButtonHandler: @escaping () -> ()) -> UIViewController {
        let alert = UIAlertController(title: "👾", message: "It is an interesting test task", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            okButtonHandler()
        })
        return alert
    }
    
    static func errorAlert(message: String, okButtonHandler: @escaping () -> ()) -> UIViewController {
        let alert = UIAlertController(title: "Error!!!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            okButtonHandler()
        })
        return alert
    }
}
