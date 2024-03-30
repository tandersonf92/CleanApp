import Domain
import Foundation

public final class MainQueueDispatchDecorator<T> {

    private let instance: T

    public init(_ instance: T) {
        self.instance = instance
    }

    func dispatch(completion: @escaping() -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { completion() }
        }
        completion()
    }
}

extension MainQueueDispatchDecorator: AddAccountUseCase where T: AddAccountUseCase {
    public func add(addAccountModel: AddAccountModel, completion: @escaping (AddAccountUseCase.Result) -> Void) {
        instance.add(addAccountModel: addAccountModel) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
