//
//  UIViewController+JGProgressHUD.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 29/12/22.
//

import UIKit
import IHProgressHUD

extension UIViewController {
    
    func showIndicator(withTitle title: String = Content.loading) {
        IHProgressHUD.show(withStatus: title)
    }
    
    func hideIndicator() {
        IHProgressHUD.dismiss()
    }
}
