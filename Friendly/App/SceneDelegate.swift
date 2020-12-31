//
//  SceneDelegate.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 28.12.20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let splitViewController = UISplitViewController(style: .doubleColumn)
        splitViewController.delegate = self
        
        let masterViewController = MasterViewController()
        let detailViewController = DetailViewController()
        masterViewController.delegate = detailViewController
        
        let masterNavController = UINavigationController(rootViewController: masterViewController)
        let detailNavController = UINavigationController(rootViewController: detailViewController)
        
        splitViewController.setViewController(masterNavController, for: .primary)
        splitViewController.setViewController(detailNavController, for: .secondary)
        
        if detailViewController.detailItem == nil {
            splitViewController.show(.primary)
        }
        
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        let vc = svc.viewController(for: .secondary)
        let navController = vc as! UINavigationController
        let detailViewController = navController.viewControllers.first as! DetailViewController
        
        if detailViewController.detailItem == nil {
            return .primary
        }
        return .secondary
    }
}

