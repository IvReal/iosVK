//  GroupsNC.swift
//  Lesson1.1
//  Created by Iv on 29/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class GroupsNC: UINavigationController, UINavigationControllerDelegate {

    let interactiveTransition = GroupsInteractiveTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
 
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            return interactiveTransition.hasStarted ? interactiveTransition : nil
    }

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            if operation == .push {
                self.interactiveTransition.viewController = toVC
                return nil // standard push
            } else if operation == .pop {
                if navigationController.viewControllers.first != toVC {
                    self.interactiveTransition.viewController = toVC
                }
                return GroupsPopAnimator()
            }
            return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

class GroupsInteractiveTransition: UIPercentDrivenInteractiveTransition {

    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self,
                action: #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    var hasStarted: Bool = false
    var shouldFinish: Bool = false

    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
            case .began:
                self.hasStarted = true
                self.viewController?.navigationController?.popViewController(animated: true)
            case .changed:
                let translation = recognizer.translation(in: recognizer.view)
                let relativeTranslation = translation.x / (recognizer.view?.bounds.width ?? 1)
                let progress = max(0, min(1, relativeTranslation))
                self.shouldFinish = progress > 0.45
                self.update(progress)
            case .ended:
                self.hasStarted = false
                self.shouldFinish ? self.finish() : self.cancel()
            case .cancelled:
                self.hasStarted = false
                self.cancel()
            default: return
        }
    }
}

final class GroupsPopAnimator: NSObject, UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    /*
     Простая анимация: source перемещается вправо и становится прозрачным
     При использовании в интерактивном режиме позволяет "подсмотреть" destination не переходя на него
     - все какая-то польза
    */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        destination.view.frame = source.view.frame
        source.view.alpha = 1
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
            animations: {
                source.view.transform = CGAffineTransform(translationX: source.view.frame.width, y: 0)
                source.view.alpha = 0
            },
            completion:  { finished in
                if finished && !transitionContext.transitionWasCancelled {
                    source.removeFromParent()
                } else if transitionContext.transitionWasCancelled {
                    source.view.alpha = 1
                }
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
            })
    }
}
