import UIKit

class CustomPresentationController: UIPresentationController {
  init(presentedViewController: UIViewController, presenting: UIViewController?, interactionTransition: UIPercentDrivenInteractiveTransition) {
    self.interactionTransition = interactionTransition
    super.init(presentedViewController: presentedViewController, presenting: presenting)
  }
  
  open override func presentationTransitionWillBegin() {
    print(containerView!)

    if let containerView {
      let dimmingView = UIView()
      dimmingView.frame = containerView.frame
      dimmingView.alpha = 0.3
      dimmingView.backgroundColor = .black
      containerView.insertSubview(dimmingView, at: 0)
      let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
      containerView.addGestureRecognizer(panGesture)
      
      let transitionCoordinator = presentingViewController.transitionCoordinator

      let circle = UIView(frame: CGRect(origin: .init(x: -100, y: -100), size: .init(width: 100, height: 100)))
      circle.backgroundColor = .blue
      transitionCoordinator?.animate(alongsideTransition: { context in
        context.containerView.addSubview(circle)
        circle.backgroundColor = .yellow
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 50
        circle.frame.origin = .init(x: 300, y: 300)
      }, completion: { context in
        circle.removeFromSuperview()
      })
    }
    print("presentationTransitionWillBegin")
  }

  open override func presentationTransitionDidEnd(_ completed: Bool) {
    print("presentationTransitionDidEnd: \(completed)")
  }

  open override func dismissalTransitionWillBegin() {
    print("dismissalTransitionWillBegin")

  }

  open override func dismissalTransitionDidEnd(_ completed: Bool) {
    print("dismissalTransitionDidEnd: \(completed)")
  }

  override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    print("containerViewWillLayoutSubviews")
  }

  override func containerViewDidLayoutSubviews() {
    super.containerViewDidLayoutSubviews()
    print("containerViewDidLayoutSubviews")
  }

  private let interactionTransition: UIPercentDrivenInteractiveTransition

  @objc func didPan(_ pan: UIPanGestureRecognizer) {
      let translation = pan.translation(in: containerView).y
      let distance = translation / containerView!.bounds.height
      print(distance)
//      self.interactionTransition.completionSpeed = 1.1 - distance

      switch (pan.state) {
      case .began:
        break
      case .changed:
        print("UIPercentDrivenInteractiveTransition: \(distance)")
        self.interactionTransition.update(distance)
      default:
          if distance < 0.4 {
              self.interactionTransition.cancel()
          } else {
              self.interactionTransition.finish()
          }
      }
  }
}

class CustomPercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition {
  override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
    super.startInteractiveTransition(transitionContext)
  }

  override func update(_ percentComplete: CGFloat) {
    super.update(percentComplete)
    print("test")
  }
}
