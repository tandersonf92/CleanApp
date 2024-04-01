import Domain
import Presentation
import Validation
import UI

func makeSignUpController(addAccount: AddAccountUseCase) -> SignUpViewController {
    let controller = SignUpViewController.instantiate()
    let validationComposite = ValidationComposite(validations: makeSignUpValidations())
    let presenter = SignUpPresenter(alertView: WeakVarProxy(controller),
                                    loadingView: WeakVarProxy(controller),
                                    addAccount: addAccount,
                                    validation: validationComposite)
    controller.signUp = presenter.signUp
    return controller
}

func makeSignUpValidations()  ->[Validation] {
    return [RequiredFieldValidation(fieldName: "name", fieldLabel: "Nome"),
            RequiredFieldValidation(fieldName: "email", fieldLabel: "Email"),
            EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: makeEmailValidatorAdapter()),
            RequiredFieldValidation(fieldName: "password", fieldLabel: "Senha"),
            RequiredFieldValidation(fieldName: "passwordConfirmation", fieldLabel: "Confirmar senha"),
            CompareFieldsValidation(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Confirmar senha")]
}
