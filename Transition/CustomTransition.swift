import UIKit

public enum Direction {
  case forward
  case backward
}

public class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
  public init(direction: Direction) {
    self.direction = direction
  }

  public let direction: Direction

  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let context = ViewContext(transitionContext) else {
      assert(false)
      return
    }

    UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
      context.to.view.backgroundColor = .purple
    }
  }

  public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    if let animator {
      return animator
    }

    let animator = prepareAnimator(using: transitionContext)
    self.animator = animator

    if transitionContext.isInteractive {
      animator.pauseAnimation()
    } else {
      animator.startAnimation()
    }

    return animator
  }

  private func prepareAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewPropertyAnimator {
    self.transitionContext = transitionContext
    let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut)
    self.animator = animator

    guard let context = ViewContext(transitionContext) else {
      assert(false)
      return animator
    }

    let from = context.from
    let to = context.to

    switch direction {
    case .forward:
      if to.view.superview == nil {
        transitionContext.containerView.addSubview(to.view)
      }
      to.view.frame = CGRect(x: from.frame.midX, y: from.frame.height, width: 0, height: 0)
      animator.addAnimations {
        to.view.frame = from.frame
      }
    case .backward:
      if to.view.superview == nil {
        transitionContext.containerView.insertSubview(to.view, belowSubview: from.view)
      }
      to.view.frame = from.frame
      animator.addAnimations {
        from.view.frame = CGRect(origin: .init(x: 300, y: 300), size: CGSize(width: 100, height: 100))
      }
    }

    animator.addCompletion { [transitionContext] state in
      let finished = state == .end
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      if self.direction == .backward, !transitionContext.transitionWasCancelled {
        from.view.removeFromSuperview()
      }
    }

    return animator
  }

  private var startY: CGFloat = 0

  private let duration: CGFloat = 1
  private var animator: UIViewPropertyAnimator?
  private var transitionContext: UIViewControllerContextTransitioning?
}

extension CustomTransition: UIViewControllerInteractiveTransitioning {
  public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(sender:)))
    transitionContext.containerView.addGestureRecognizer(gesture)
  }

  public var wantsInteractiveStart: Bool { true }

  @objc
  private func onPan(sender: UIPanGestureRecognizer) {
    guard let animator, let transitionContext else {
      assert(false)
      return
    }
    switch sender.state {
    case .began:
      print("begin")
      animator.pauseAnimation()
      startY = sender.translation(in: sender.view).y
    case .changed:
      let translation = sender.translation(in: sender.view)
      let percent = min((startY - translation.y) / 300, 1)
      animator.fractionComplete = percent
      transitionContext.updateInteractiveTransition(percent)
      print("\(percent)")
    case .cancelled, .ended:
      if animator.fractionComplete < 0.5 {
        animator.isReversed = true
        transitionContext.cancelInteractiveTransition()
      } else {
        transitionContext.finishInteractiveTransition()
      }
      let factor = 1 - animator.fractionComplete
      animator.continueAnimation(withTimingParameters: nil, durationFactor: factor)
    default:
      print(sender.state)
    }
  }
}

