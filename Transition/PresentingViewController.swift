import UIKit
import HelloSwift
import HellObjectiveC

class PresentingViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red

    let button = UIButton(type: .system)
    button.setTitle("Present", for: .normal)
    view.addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
    button.addTarget(self, action: #selector(onDidTap), for: .touchUpInside)
  }

  @objc
  private func onDidTap() {
    let child = PresentedViewController()
    child.modalPresentationStyle = .custom
    child.transitioningDelegate = self
    present(child, animated: true)
  }

  private func displayWithChild() {
    let child = PresentedViewController()
    addChild(child)
    child.view.frame = CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 200, height: 200))
    view.addSubview(child.view)
    let transition = CustomTransition(direction: .forward)
    let context = CustomTransitionContext(
      containerView: view,
      from: self,
      to: child)
    {_ in
      child.didMove(toParent: self)
    }
    transition.animateTransition(using: context)
  }

  lazy var interactionTransition = CustomPercentDrivenInteractiveTransition()
  var transition: CustomTransition?
}

extension PresentingViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition = CustomTransition(direction: .forward)
    return transition
  }

  func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return transition
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition = CustomTransition(direction: .backward)
    return transition
  }

  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return transition
  }

  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let custom = CustomPresentationController(presentedViewController: presented, presenting: presenting, interactionTransition: interactionTransition)
    return custom
  }
}

class PresentedViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .green

    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)
    button.setTitle("Dismiss", for: .normal)
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
    button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
  }

  @objc
  private func didTap() {
    dismiss(animated: true)
  }
}
