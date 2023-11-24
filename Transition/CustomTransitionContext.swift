import UIKit

public class CustomTransitionContext: NSObject, UIViewControllerContextTransitioning {
  init(
    containerView: UIView,
    from: UIViewController,
    to: UIViewController,
    completion: ((Bool) -> Void)? = nil)
  {
    self.containerView = containerView
    self.completion = completion
    self.from = from
    self.to = to
  }
  public var containerView: UIView

  public var isAnimated: Bool = false

  public var isInteractive: Bool = false

  public var transitionWasCancelled: Bool = false

  public var presentationStyle: UIModalPresentationStyle = .none

  public func updateInteractiveTransition(_ percentComplete: CGFloat) {

  }

  public func finishInteractiveTransition() {

  }

  public func cancelInteractiveTransition() {

  }

  public func pauseInteractiveTransition() {

  }

  public func completeTransition(_ didComplete: Bool) {
    guard let completion else {
      return
    }

    // Clear out the completion to prevent the block from being called multiple times
    self.completion = nil

    transitionWasCancelled = (didComplete == false)
    completion(didComplete)
  }

  public func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
    switch key {
    case .from:
      return from
    case .to:
      return to
    default:
      return nil
    }
  }

  public func view(forKey key: UITransitionContextViewKey) -> UIView? {
    switch key {
    case .from:
      return from.view
    case .to:
      return to.view
    default:
      return nil
    }
  }

  public var targetTransform: CGAffineTransform = .identity

  public func initialFrame(for vc: UIViewController) -> CGRect {
    return vc.view.frame
  }

  public func finalFrame(for vc: UIViewController) -> CGRect {
    return vc.view.frame
  }

  @objc
  var _animator: UIViewControllerAnimatedTransitioning {
    let a = CustomTransition(direction: .forward)
    return a
  }

  @objc
  var _initiallyInteractive: Bool = true

  private var completion: ((Bool) -> Void)?
  private var from: UIViewController
  private var to: UIViewController
}
