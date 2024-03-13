import Domain
import UI

enum SignUpComposers {
    static func composeControllerWith(addAccount: AddAccountUseCase) -> SignUpViewController {
        SignUpFactory.build(addAccount: addAccount)
    }
}
