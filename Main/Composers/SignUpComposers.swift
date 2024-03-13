import Domain
import UI

enum SignUpComposer {
    static func composeControllerWith(addAccount: AddAccountUseCase) -> SignUpViewController {
        SignUpFactory.build(addAccount: addAccount)
    }
}
