//
//  ViewController.swift
//  LBZSpinner
//
//  Created by LeBzul on 18/02/2016.
//  Copyright © 2016 LeBzul. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LBZSpinnerDelegate {
    
    @IBOutlet var spinnerTop:LBZSpinner!
    @IBOutlet var spinnerMid:LBZSpinner!
    @IBOutlet var spinnerBot:LBZSpinner!

    @IBOutlet var spinnerCode:LBZSpinner!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let listTop = ["Pulp Fiction","Django","Reservoir dogs"]
        let listMid = ["0","1","2","3","4","5","6","7","8","9"]
        let listBot = ["Hello","Cherry","Home","Back","True","Granted"]

        spinnerTop.updateList(listTop)
        spinnerMid.updateList(listMid)
        spinnerBot.updateList(listBot)

        spinnerTop.delegate = self
        spinnerMid.delegate = self
        spinnerBot.delegate = self

        createSpinnerByCode()

        if spinnerBot.selectedIndex == LBZSpinner.INDEX_NOTHING {
            print("NOTHING VALUE")
            spinnerBot.changeSelectedIndex(1)
        }
    }

    func createSpinnerByCode() {
        let listCode = ["Books","Video","Streaming","Download","Upload"]
        spinnerCode = LBZSpinner(frame: CGRect(x: 90,y: 30,width: 180,height: 45))
        spinnerCode.delegate = self
        spinnerCode.textColor = UIColor.redColor()
        spinnerCode.lineColor = UIColor.purpleColor()
        spinnerCode.decoratedSpinner(UIColor.purpleColor(), lineColor: UIColor.brownColor(), text: "Choose value")
        spinnerCode.decoratedDropDownList(UIColor.lightGrayColor(), textColor: UIColor.redColor(), withStroke: true, strokeSize: 5, strokeColor: nil)
        spinnerCode.updateList(listCode)
        self.view.addSubview(spinnerCode)
    }


    func spinnerChoose(spinner:LBZSpinner, index:Int,value:String) {
        var spinnerName = ""
        if spinner == spinnerTop { spinnerName = "spinnerTop" }
        if spinner == spinnerMid { spinnerName = "spinnerMid" }
        if spinner == spinnerBot { spinnerName = "spinnerBot" }
        if spinner == spinnerCode { spinnerName = "spinnerCode" }

        print("Spinner : \(spinnerName) : { Index : \(index) - \(value) }")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

