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
        // Do any additional setup after loading the view.
    }

}

private extension ViewController {
    
    func showEnvValue() {
 //       valueLabel1.text = SwiftPackageKeys
//        valueLabel1.text = Swi
    }
    
}

public extension SwiftPackageKeys {
    public static var keyName: String {
        return "KEY_VALUE"
    }
    public static var keyname2: String {
        return "KeyValue2"
    }
    public static var keyName3: String {
        return "KeyValue3"
    }
}
