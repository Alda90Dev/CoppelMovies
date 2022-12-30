//
//  LoginView.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 28/12/22.
//

import UIKit
import Combine

/////////////////////// LOGIN VIEW PROTOCOL
protocol LoginViewProtocol: AnyObject {
    var presenter: LoginPresenterProtocol? { get set }
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// LOGIN  VIEW
///////////////////////////////////////////////////////////////////////////////////////////////////

class LoginView: UIViewController {
    
    private lazy var imgTop: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = ImageCatalog.topImage
        return image
    }()
    
    private lazy var imgLogo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = ImageCatalog.logoLogin
        return image
    }()
    
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 15
        return stack
    }()
    private lazy var txtUser: TextFieldWithPadding = {
        let txt = TextFieldWithPadding()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholderText = Content.userName
        txt.delegate = self
        return txt
    }()
    
    private lazy var txtPassword: TextFieldWithPadding = {
        let txt = TextFieldWithPadding()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholderText = Content.Password
        txt.isSecureTextEntry = true
        txt.delegate = self
        return txt
    }()
    
    private lazy var lblUserError: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .red
        lbl.text = Content.required
        lbl.isHidden = true
        return lbl
    }()
    
    private lazy var lblPasswordError: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .red
        lbl.text = Content.required
        lbl.isHidden = true
        return lbl
    }()
    
    private lazy var lblLoginError: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .red
        lbl.isHidden = true
        lbl.numberOfLines = 3
        return lbl
    }()
    
    private lazy var btnLogin: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(Content.logIn, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.backgroundColor = ColorCatalog.principal.cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(tappedAction), for: .touchUpInside)
        return btn
    }()
    
    
    
    var presenter: LoginPresenterProtocol?

    private var subscriptions = Set<AnyCancellable>()
    private var userValue: String?
    private var passwordValue: String?
    private let presenterInput: LoginPresenterInput = LoginPresenterInput()
    private var topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>?
    private var constraintsArray: [NSLayoutConstraint] = []
    private let topImgHeight = (UIScreen.main.bounds.height / 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorCatalog.background
        setupView()
        bind()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        determineDeviceOrientation()
    }
}

private extension LoginView {
    
    func bind() {
        txtUser.textPublisher
            .sink(receiveValue: { [weak self] text in
                self?.lblUserError.isHidden = !text.isEmpty
                self?.userValue = text
            }).store(in: &subscriptions)
        
        txtPassword.textPublisher
            .sink(receiveValue: { [weak self] text in
                self?.lblPasswordError.isHidden = !text.isEmpty
                self?.passwordValue = text
            }).store(in: &subscriptions)
        
        let output = presenter?.bind(input: presenterInput)
        
        output?.loginDataErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                self?.hideIndicator()
                guard let error = error else {
                    return
                }
                self?.btnLogin.isEnabled = true
                self?.lblLoginError.text = error.localizedDescription
                self?.lblLoginError.isHidden = false
        }).store(in: &subscriptions)
    }
    
    func setupView() {
        
        topAnchor = imgTop.bottomAnchor
        
        stackView.addArrangedSubview(lblUserError)
        stackView.addArrangedSubview(txtUser)
        stackView.addArrangedSubview(lblPasswordError)
        stackView.addArrangedSubview(txtPassword)
        
        view.addSubview(imgTop)
        view.addSubview(imgLogo)
        view.addSubview(stackView)
        view.addSubview(btnLogin)
        view.addSubview(lblLoginError)
        
        setConstraints()
    }
    
    func setConstraints() {
        
        constraintsArray = [
            imgTop.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            imgTop.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imgTop.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            imgTop.heightAnchor.constraint(equalToConstant: topImgHeight),
            
            imgLogo.topAnchor.constraint(equalTo: topAnchor ?? view.topAnchor, constant: 10),
            imgLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imgLogo.widthAnchor.constraint(equalToConstant: 100),
            imgLogo.heightAnchor.constraint(equalToConstant: 100),
            
            stackView.topAnchor.constraint(equalTo: imgLogo.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            
            btnLogin.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            btnLogin.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            btnLogin.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            btnLogin.heightAnchor.constraint(equalToConstant: 55),
            
            lblLoginError.topAnchor.constraint(equalTo: btnLogin.bottomAnchor, constant: 10),
            lblLoginError.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lblLoginError.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraintsArray)
    }
    
    func determineDeviceOrientation() {
        if UIDevice.current.orientation.isLandscape {
            topAnchor = view.topAnchor
        } else {
            topAnchor = imgTop.bottomAnchor
        }
        
        NSLayoutConstraint.deactivate(constraintsArray)
        setConstraints()
    }
    
    @objc func tappedAction() {
        if let input = isInputValid(),
            input.0 {
            DispatchQueue.main.async {
                self.lblLoginError.isHidden = true
                self.btnLogin.isEnabled = false
                self.txtPassword.resignFirstResponder()
                self.showIndicator()
            }
            presenterInput.tapToLogin.send((input.1, input.2))
        }
    }
    
    func isInputValid() -> (Bool, String, String)? {
        guard let userValue = userValue,
              !userValue.isEmpty else {
            lblUserError.isHidden = false
            return nil
        }
        
        guard let passwordValue = passwordValue,
              !passwordValue.isEmpty else {
            lblPasswordError.isHidden = false
            return nil
        }
        
        return (true, userValue, passwordValue)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txtUser:
            txtPassword.becomeFirstResponder()
        default:
            txtPassword.resignFirstResponder()
        }
        
        return true
    }
}

extension LoginView: LoginViewProtocol { }

