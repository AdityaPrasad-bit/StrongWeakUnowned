//
//  HomeViewController.swift
//  WeakOwned
//
//  Created by Aditya on 10/11/24.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setObserver()
        addTimer()
    }
    func setObserver() {
        
    }

    func printHello(){
        print("Hello")
    }
    func addTimer(){
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 4, execute: {[unowned self] in
            self.printHello()
        })
    }
    deinit {
        print("\(self) is Deallocated")
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
