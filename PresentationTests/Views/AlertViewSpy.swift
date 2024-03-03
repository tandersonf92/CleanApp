import Presentation

class AlertViewSpy: AlertView {
    var viewModel: AlertViewModel?
    var emit: ((AlertViewModel) -> Void)?

    func observe(completion: @escaping (AlertViewModel) -> Void) {
        self.emit = completion
    }

    func showMessage(viewModel: AlertViewModel) {
        self.emit?(viewModel)
    }
}
