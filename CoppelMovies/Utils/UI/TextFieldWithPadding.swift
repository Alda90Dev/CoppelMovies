//
//  TextFieldWithPadding.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 28/12/22.
//

import UIKit

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 10,
        left: 20,
        bottom: 10,
        right: 20
    )
    
    var placeholderText: String? {
        didSet {
            let placeholderTextColor = NSAttributedString(string: placeholderText ?? "",
                                                          attributes: [NSAttributedString.Key.foregroundColor: ColorCatalog.placeholder])
            
            attributedPlaceholder = placeholderTextColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white.withAlphaComponent(0.9)
        borderStyle = .roundedRect
        textColor = ColorCatalog.text
        autocapitalizationType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
}
