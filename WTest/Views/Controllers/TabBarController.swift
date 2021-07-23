//
//  TabBarController.swift
//  WTest
//
//  Created by Leonardo Bilia on 22/07/21.
//

import UIKit

class TabBarController: UITabBarController {
    
    private var previousController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupItems()
    }
    
    private func setupItems() {
        let zipcodeController = setupNavigation(for: ZipCodeTableViewController(), title: Constants.Title.zipCode, icon: UIImage(systemName: "house"))
        let articlesController = setupNavigation(for: ArticlesTableViewController(), title: Constants.Title.articles, icon: UIImage(systemName: "book"))
        let formController = setupNavigation(for: FormViewController(), title: Constants.Title.form, icon: UIImage(systemName: "highlighter"))
        viewControllers = [zipcodeController, articlesController, formController]
    }
    
    private func setupNavigation(for rootController: UIViewController, title: String, icon: UIImage?) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootController)
        navigationController.tabBarItem.image = icon
        rootController.navigationController?.navigationBar.prefersLargeTitles = true
        rootController.navigationItem.title = title
        return navigationController
    }
}
