import Presentation

func makeSignUpViewModel(name: String = "any_name", email: String = "any_email@email.com", password: String = "any_password", passwordConfirmation: String = "any_password") -> SignUpRequest {
    SignUpRequest(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
}

func makeLoginViewModel(email: String = "any_email@email.com", password: String = "any_password") -> LoginRequest {
    LoginRequest(email: email, password: password)
}
