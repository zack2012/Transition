import UIKit

public class ViewContext {
  public init?(_ context: UIViewControllerContextTransitioning) {
    guard
      let toViewController = context.viewController(forKey: .to),
      let fromViewController = context.viewController(forKey: .from),
      let toView = context.view(forKey: .to) ?? toViewController.view,
      let fromView = context.view(forKey: .from) ?? fromViewController.view
    else {
      context.completeTransition(false)
      return nil
    }

    func transitionFrame(for rect: CGRect) -> CGRect? {
      rect == .zero ? nil : rect
    }

    let toFinalFrame = transitionFrame(for: context.finalFrame(for: toViewController))
      ?? context.containerView.bounds

    let fromFinalFrame = transitionFrame(for: context.finalFrame(for: fromViewController))
      ?? context.containerView.bounds

    to = .init(view: toView, viewController: toViewController, frame: toFinalFrame)
    from = .init(view: fromView, viewController: fromViewController, frame: fromFinalFrame)
    container = context.containerView
    underlyingContext = context
  }
  public let to: Destination
  public let from: Destination
  public let container: UIView
  public let underlyingContext: UIViewControllerContextTransitioning

  public struct Destination {
    public let view: UIView
    public let viewController: UIViewController
    public let frame: CGRect
  }
}
