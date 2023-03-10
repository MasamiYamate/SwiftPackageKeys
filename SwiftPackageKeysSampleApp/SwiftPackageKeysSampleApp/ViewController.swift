//
//  ViewController.swift
//  SwiftPackageKeysSampleApp
//
//  Created by Masami on 2023/02/12.
//

import UIKit
import SwiftPackageKeys

final class ViewController: UIViewController {
    
    @IBOutlet private weak var valueLabel1: UILabel!
    
    @IBOutlet private weak var valueLabel2: UILabel!
    
    @IBOutlet private weak var valueLabel3: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        showEnvValue()
    }

}

private extension ViewController {
    
    func showEnvValue() {
        valueLabel1.text = SwiftPackageKeys.keyName
        valueLabel2.text = SwiftPackageKeys.keyname2
        valueLabel3.text = SwiftPackageKeys.keyName3
    }
    
}
