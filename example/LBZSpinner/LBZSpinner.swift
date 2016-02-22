//
//  LBZSpinner.swift
//  LBZSpinner
//
//  Created by LeBzul on 18/02/2016.
//  Copyright © 2016 LeBzul. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class LBZSpinner : UIView, UITableViewDelegate, UITableViewDataSource {

    private var firstDraw:Bool = true
    
    let heightTableviewCell:CGFloat = 45
    var heightTableview:CGFloat = 200

    //public variable
    static var INDEX_NOTHING = 0

    //spinner
    @IBInspectable var textColor: UIColor = UIColor.grayColor() { didSet{ updateUI() } }
    @IBInspectable var lineColor: UIColor = UIColor.grayColor() { didSet{ updateUI() } }
    @IBInspectable var list:[String]  = [String]() { didSet{ updateUI() } }
    @IBInspectable var text: String = "" { didSet{ updateUI() } }
  
    
    //Drop down list
    @IBInspectable var dDLMaxSize: CGFloat = 200
    @IBInspectable var dDLColor: UIColor = UIColor.whiteColor()
    @IBInspectable var dDLTextColor: UIColor = UIColor.grayColor()
    @IBInspectable var dDLStroke: Bool = true
    @IBInspectable var dDLStrokeColor: UIColor = UIColor.grayColor()
    @IBInspectable var dDLStrokeSize: CGFloat = 1
    

    //Drop down list view back
    @IBInspectable var dDLblurEnable: Bool = true


    var delegate:LBZSpinnerDelegate!

    //actual seleted index
    private(set) internal var selectedIndex = INDEX_NOTHING

    private var labelValue: UILabel!
    private var blurEffectView:UIVisualEffectView!
    private var viewChooseDisable: UIView!
    private var tableviewChoose: UITableView!
    private var tableviewChooseShadow: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initCustomView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initCustomView()
    }

    override func prepareForInterfaceBuilder() {
        backgroundColor = UIColor.clearColor()  // clear black background IB
    }



    private func initCustomView() {
        backgroundColor = UIColor.clearColor()  // clear black background
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged", name: UIDeviceOrientationDidChangeNotification, object: nil)

        //Open spinner click
        let gesture = UITapGestureRecognizer(target: self, action: "openSpinner:")
        addGestureRecognizer(gesture)
        heightTableview = heightTableviewCell*CGFloat(list.count)
        
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if firstDraw {
            //create spinner label
            labelValue = UILabel(frame: bounds)
            addSubview(labelValue)
            updateUI()
            firstDraw = false
        }
        
        drawCanvas(frame: rect)
    }

    func changeSelectedIndex(index:Int) {
        if list.count > selectedIndex {
            text = list[selectedIndex]
            updateUI()

            if (delegate != nil) {
                delegate.spinnerChoose(self,index:selectedIndex, value: list[selectedIndex])
            }
        }
    }

    private func updateUI() {
        if (labelValue != nil) {
            labelValue.text = text
            labelValue.textColor = textColor
        }
        setNeedsDisplay()
    }

    //Config spinner style
    func decoratedSpinner(textColor:UIColor!,lineColor:UIColor!,text:String!) {
        if(textColor != nil) { self.textColor=textColor }
        if(lineColor != nil) { self.lineColor=lineColor }
        if(text != nil) { self.text=text }
    }

    //Config drop down list style
    func decoratedDropDownList(backgroundColor:UIColor!,textColor:UIColor!,withStroke:Bool!,strokeSize:CGFloat!,strokeColor:UIColor!) {

        if(backgroundColor != nil) { dDLColor=backgroundColor }
        if(textColor != nil) { dDLTextColor=textColor }
        if(withStroke != nil) { dDLStroke=withStroke }
        if(strokeSize != nil) { dDLStrokeSize=strokeSize }
        if(strokeColor != nil) { dDLStrokeColor=strokeColor }
    }


    //Update drop down list
    func updateList(list:[String]) {
        self.list = list;
        heightTableview = heightTableviewCell*CGFloat(list.count)
        if(tableviewChoose != nil) {
            tableviewChoose.reloadData()
        }
    }

    
    //Open spinner animation
    func openSpinner(sender:UITapGestureRecognizer){

        heightTableview = heightTableviewCell*CGFloat(list.count)
        let parentView = findLastUsableSuperview()
        let globalPoint = convertPoint(bounds.origin, toView:parentView) // position spinner in superview

        viewChooseDisable = UIView(frame: parentView.frame) // view back click

        if(dDLblurEnable) {  // with blur effect
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.alpha = 0 // blur effect alpha
            blurEffectView.frame = viewChooseDisable.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            viewChooseDisable.addSubview(blurEffectView)
        }


        var expandBottomDirection = true
        if((globalPoint.y+heightTableview) < parentView.frame.height) {
            expandBottomDirection = true
        } else if((globalPoint.y-heightTableview) > 0) {
            expandBottomDirection = false
        } else {

            //find best direction
            let margeBot = parentView.frame.height - globalPoint.y
            let margeTop =  parentView.frame.height - (parentView.frame.height - globalPoint.y)

            if( margeBot > margeTop ) {
                expandBottomDirection = true
                heightTableview = margeBot - 5
            } else {
                expandBottomDirection = false
                heightTableview = margeTop - 5
            }

        }

        if(heightTableview > dDLMaxSize) {
            heightTableview = dDLMaxSize
        }

        // expand bottom animation
        if (expandBottomDirection) {
            tableviewChoose = UITableView(frame:  CGRectMake(globalPoint.x , globalPoint.y, frame.size.width, 0))
            tableviewChooseShadow = UIView(frame: tableviewChoose.frame)

            UIView.animateWithDuration(0.3,
                delay: 0.0,
                options: UIViewAnimationOptions.TransitionFlipFromBottom,
                animations: {
                    self.tableviewChoose.frame.size.height = self.heightTableview
                    self.tableviewChooseShadow.frame.size.height = self.heightTableview

                    if self.blurEffectView != nil {
                        self.blurEffectView.alpha = 0.5
                    }

                },
                completion: { finished in
            })

        }
        // expand top animation
        else {

            tableviewChoose = UITableView(frame:  CGRectMake(globalPoint.x , globalPoint.y, frame.size.width, self.frame.height))
            tableviewChooseShadow = UIView(frame: tableviewChoose.frame)

            UIView.animateWithDuration(0.3,
                delay: 0.0,
                options: UIViewAnimationOptions.TransitionFlipFromBottom,
                animations: {
                    self.tableviewChoose.frame.origin.y = globalPoint.y-self.heightTableview+self.frame.height
                    self.tableviewChoose.frame.size.height = self.heightTableview
                    self.tableviewChooseShadow.frame.origin.y = globalPoint.y-self.heightTableview+self.frame.height
                    self.tableviewChooseShadow.frame.size.height = self.heightTableview

                    if self.blurEffectView != nil {
                        self.blurEffectView.alpha = 0.5
                    }
                },
                completion: { finished in
            })
            
        }


        // config tableview drop down list
        tableviewChoose.backgroundColor = dDLColor
        tableviewChoose.tableFooterView = UIView() //Eliminate Extra separators below UITableView
        tableviewChoose.delegate = self
        tableviewChoose.dataSource = self
        tableviewChoose.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        tableviewChoose.userInteractionEnabled = true
        tableviewChoose.showsHorizontalScrollIndicator = false
        tableviewChoose.showsVerticalScrollIndicator = false
        tableviewChoose.separatorStyle = UITableViewCellSeparatorStyle.None
        tableviewChoose.layer.cornerRadius = 5

        //Show stroke
        if(dDLStroke) {
            tableviewChoose.layer.borderColor = dDLStrokeColor.CGColor
            tableviewChoose.layer.borderWidth = dDLStrokeSize
        }
        
        // config shadow drop down list
        tableviewChooseShadow.backgroundColor = dDLColor
        tableviewChooseShadow.layer.shadowOpacity = 0.5;
        tableviewChooseShadow.layer.shadowOffset = CGSizeMake(3, 3);
        tableviewChooseShadow.layer.shadowRadius = 5;
        tableviewChooseShadow.layer.cornerRadius = 5
        tableviewChooseShadow.layer.masksToBounds = false
        tableviewChooseShadow.clipsToBounds = false

        
        // add to superview
        parentView.addSubview(viewChooseDisable)
        parentView.addSubview(tableviewChooseShadow)
        parentView.addSubview(tableviewChoose)

        // close spinner click back
        let gesture = UITapGestureRecognizer(target: self, action: "closeSpinner")
        viewChooseDisable.addGestureRecognizer(gesture)

    }

    
    // close spinner animation
    func closeSpinner() {

        if(tableviewChoose != nil) {
            UIView.animateWithDuration(0.3,
                delay: 0.0,
                options: UIViewAnimationOptions.TransitionFlipFromBottom,
                animations: {
                    self.tableviewChoose.alpha = 0.0
                    self.tableviewChooseShadow.alpha = 0.0
                    self.viewChooseDisable.alpha = 0.0
                },
                completion: { finished in

                    // delete dropdown list
                    self.tableviewChoose.removeFromSuperview()
                    self.viewChooseDisable.removeFromSuperview()
                    self.tableviewChooseShadow.removeFromSuperview()

                    self.tableviewChoose = nil
                    self.tableviewChooseShadow = nil
                    self.viewChooseDisable = nil
            })
        }
    }


    // find usable superview
    private func findLastUsableSuperview() -> UIView {
        return (window?.subviews[0])!
    }


    //draw background spinner
    private func drawCanvas(frame frame: CGRect = CGRectMake(0, 0, 86, 11)) {
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(frame.maxX - 11, frame.maxY))
        bezierPath.addLineToPoint(CGPointMake(frame.maxX, frame.maxY))
        bezierPath.addLineToPoint(CGPointMake(frame.maxX, frame.maxY - 11))
        bezierPath.addLineToPoint(CGPointMake(frame.maxX - 11, frame.maxY))
        bezierPath.closePath()
        bezierPath.lineCapStyle = .Square;
        bezierPath.lineJoinStyle = .Bevel;

        lineColor.setFill()
        bezierPath.fill()

        let rectanglePath = UIBezierPath(rect: CGRectMake(frame.minX, frame.minY + frame.height - 1, frame.width, 1))
        lineColor.setFill()
        rectanglePath.fill()
    }

    func orientationChanged()
    {
        /*
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {}
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {}
        */
        closeSpinner()
    }
    
    /** 
     * TableView Delegate method
     **/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        labelValue.text = list[indexPath.row]
        if (delegate != nil) {
            delegate.spinnerChoose(self,index: indexPath.row, value: list[indexPath.row])
        }
        selectedIndex = indexPath.row
        closeSpinner()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath:indexPath) as UITableViewCell
        cell.contentView.backgroundColor = dDLColor
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.detailTextLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.textColor = dDLTextColor
        return cell
    }
}


protocol LBZSpinnerDelegate{
    func spinnerChoose(spinner:LBZSpinner, index:Int,value:String)
}
