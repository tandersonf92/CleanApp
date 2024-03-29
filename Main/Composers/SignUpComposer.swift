import Domain
import Infra
import Presentation
import Validation
import UI

enum SignUpComposer {
    static func composeControllerWith(addAccount: AddAccountUseCase) -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let validationComposite = ValidationComposite(validations: makeValidations())
        let presenter = SignUpPresenter(alertView: WeakVarProxy(controller), loadingView: WeakVarProxy(controller), addAccount: addAccount, validation: validationComposite)
        controller.signUp = presenter.signUp
        return controller
    }

    public static func makeValidations()  ->[Validation] {
        return [RequiredFieldValidation(fieldName: "name", fieldLabel: "Nome"),
                RequiredFieldValidation(fieldName: "email", fieldLabel: "Email"),
                EmailValidation(fieldName: "email", fieldLabel: "Email", emailValidator: EmailValidatorAdapter()),
                RequiredFieldValidation(fieldName: "password", fieldLabel: "Senha"),
                RequiredFieldValidation(fieldName: "passwordConfirmation", fieldLabel: "Confirmar senha"),
                CompareFieldsValidation(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Confirmar senha")]
    }
}
