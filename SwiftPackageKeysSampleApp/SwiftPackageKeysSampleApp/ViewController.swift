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
        valueLabel1.text = """
        【Key】
        \(SwiftPackageKeys.keyName.key)

        【Value】
        \(SwiftPackageKeys.keyName.value ?? "Empty")

        【Debug Value】
        \(SwiftPackageKeys.keyName.fetchValue(stage: .debug) ?? "Empty")

        【Staging Value】
        \(SwiftPackageKeys.keyName.fetchValue(stage: .staging) ?? "Empty")

        【Production Value】
        \(SwiftPackageKeys.keyName.fetchValue(stage: .production) ?? "Empty")
        """
        valueLabel2.text = """
        【Key】
        \(SwiftPackageKeys.keyName2.key)

        【Value】
        \(SwiftPackageKeys.keyName2.value ?? "Empty")

        【Debug Value】
        \(SwiftPackageKeys.keyName2.fetchValue(stage: .debug) ?? "Empty")

        【Staging Value】
        \(SwiftPackageKeys.keyName2.fetchValue(stage: .staging) ?? "Empty")

        【Production Value】
        \(SwiftPackageKeys.keyName2.fetchValue(stage: .production) ?? "Empty")
        """
        valueLabel3.text = """
        【Key】
        \(SwiftPackageKeys.keyName3.key)

        【Value】
        \(SwiftPackageKeys.keyName3.value ?? "Empty")

        【Debug Value】
        \(SwiftPackageKeys.keyName3.fetchValue(stage: .debug) ?? "Empty")

        【Staging Value】
        \(SwiftPackageKeys.keyName3.fetchValue(stage: .staging) ?? "Empty")

        【Production Value】
        \(SwiftPackageKeys.keyName3.fetchValue(stage: .production) ?? "Empty")
        """
    }
    
}
