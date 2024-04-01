import Domain
import Presentation
import Validation
import UI

func makeLoginController(authentication: AuthenticationUseCase) -> LoginViewController {
    let controller = LoginViewController.instantiate()
    let validationComposite = ValidationComposite(validations: makeLoginValidations())
    let presenter = LoginPresenter(validation: validationComposite,
                                   alertView: WeakVarProxy(controller),
                                   authentication: authentication,
                                   loadingView: WeakVarProxy(controller))
    controller.login = presenter.login
    return controller
}


func makeLoginValidations()  ->[Validation] {
    return [RequiredFieldValidation(fieldName: "email", fieldLabel: "Email"),
            EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: makeEmailValidatorAdapter()),
            RequiredFieldValidation(fieldName: "password", fieldLabel: "Senha")]
}


