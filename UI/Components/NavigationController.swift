import UIKit

public final class NavigationController: UINavigationController {
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    private func setup() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Color.primaryDark
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.scrollEdgeAppearance = appearance
    }

    public func setRootViewController(_ viewController: UIViewController) {
        setViewControllers([viewController], animated: true)
        hideBackButtonText(of: viewController)
    }

    public func pushViewController(_ viewController: UIViewController) {
        pushViewController(viewController, animated: true)
        hideBackButtonText(of: viewController)
    }

    private func hideBackButtonText(of viewController: UIViewController) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
}
