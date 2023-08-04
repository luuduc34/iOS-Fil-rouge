//
//  MyTabBarController.swift
//  Fil Rouge
//
//  Created by Duc Luu on 31/07/2023.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*tabBar.backgroundColor = .blue
         tabBar.tintColor = .orange
         tabBar.unselectedItemTintColor = .gray*/
        //Nouvelle fadon de faire depuis iOS13
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBlue
        let selectedColor: UIColor = .systemPink
        let unselectedColor: UIColor = .white.withAlphaComponent(0.4)
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes =
        [.foregroundColor: selectedColor]
        appearance.stackedLayoutAppearance.normal.iconColor = unselectedColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes =
        [.foregroundColor: unselectedColor]
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
