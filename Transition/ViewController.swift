import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func onDidTap(_ sender: Any) {
    setupTransition()
    let vc1 = PresentingViewController()
    navigationController?.pushViewController(vc1, animated: true)
  }
  
  func setupTransition() {
    guard let nav = navigationController else { return }
    nav.delegate = self
  }

  var transitions: CustomTransition?
}

extension ViewController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transitions = CustomTransition(direction: operation == .push ? .forward : .backward)
    return transitions
  }

  func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    guard let transitions else { return nil }
    switch transitions.direction {
    case .forward:
      return nil
    case .backward:
      return transitions
    }
  }
}
