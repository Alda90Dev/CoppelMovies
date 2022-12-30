//
//  SplashView.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 28/12/22.
//

import UIKit

protocol SplashViewProtocol: AnyObject {
    var presenter: SplashPresenterProtocol? { get set }
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// OPTIONS VIEW
///////////////////////////////////////////////////////////////////////////////////////////////////

class SplashView: UIViewController {
    var presenter: SplashPresenterProtocol?
    
    private let image: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        img.image = ImageCatalog.logo
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorCatalog.backgroundSplash
        view.addSubview(image)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        image.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.animate()
        })
    }
    
}

private extension SplashView {
    private func animate() {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.height - size
            
            self.image.frame = CGRect(
                x: -(diffX/2),
                y: diffY/2,
                width: size,
                height: size)
        })
        
        UIView.animate(withDuration: 1.5, animations: {
            self.image.alpha = 0
            
        }, completion: { [weak self] done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                    self?.presenter?.navigate()
                })
            }
        })
        
        
    }
}

extension SplashView: SplashViewProtocol { }
