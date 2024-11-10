//
//  ViewController.swift
//  WeakOwned
//
//  Created by Aditya on 10/11/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnHomeAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.present(navigationController, animated: true)
    }
}

