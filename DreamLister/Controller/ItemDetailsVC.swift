//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by apple on 20/06/18.
//  Copyright © 2018 shiv. All rights reserved.
//

import UIKit

class ItemDetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
