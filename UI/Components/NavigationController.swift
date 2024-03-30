import UIKit

public final class NavigationController: UINavigationController {
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Color.primaryDark
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.scrollEdgeAppearance = appearance
    }
}
