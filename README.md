
![Platform](https://img.shields.io/badge/Platform-iOS-green.svg)
![Language](https://img.shields.io/badge/Swift-2.3-blue.svg)

# LBZSpinner (Supports Swift 3)
Simple Spinner with dropdown-list for iOS (like android)
###### Demo
View live demo in Appetize :
https://appetize.io/app/m4gbf5ghpyh4bw4vpdcjxgk218?device=iphone5s&scale=75&orientation=portrait&osVersion=9.2

## Installation / Usage

Import LBZSpinner.swift in your project (or use example project)


#### Create LBZSpinner in code :
```Swift
let spinnerCode = LBZSpinner(frame: CGRect(x: 90,y: 30,width: 180,height: 45))
self.view.addSubview(spinnerCode)
```

###### Configure Spinner Style :
```Swift
spinnerCode.decoratedSpinner(UIColor.purpleColor(), lineColor: UIColor.brownColor(), text: "Choose value")
```
(Use nil parameter for default value)

###### Configure Dropdown-list Style :
```Swift
spinnerCode.decoratedDropDownList(UIColor.lightGrayColor(), textColor: UIColor.redColor(), withStroke: true, strokeSize: 5, strokeColor: nil)
```
(Use nil parameter for default value)


#### Create LBZSpinner in IB :

In Storyboard, place a simple UIView in your ViewController

###### Set "Custom class" in "Identity inspector" with LBZSpinner :

![Img](https://github.com/LeBzul/LBZSpinner/blob/master/example_images/customclass.png)

###### Configure style dropdowlist and spinner :

![Img](https://github.com/LeBzul/LBZSpinner/blob/master/example_images/configure.png)

###### LBZSpinner show in viewcontroller :

![Img](https://github.com/LeBzul/LBZSpinner/blob/master/example_images/presentation.png)


#### Configure Dropdown-list value :
```Swift
let listCode = ["Books","Video","Streaming","Download","Upload"]
spinnerCode.updateList(listCode)
```

#### Configure Delegate
Use LBZSpinnerDelegate for event return :

###### Declare use LBZSpinnerDelegate :
```Swift
class ViewController: UIViewController, LBZSpinnerDelegate 
```  
###### Set Spinner delegate :
```Swift
spinnerCode.delegate = self
```  
###### Event return method :
```Swift
func spinnerChoose(spinner:LBZSpinner, index:Int,value:String) {
    print("Spinner : \(spinner) : { Index : \(index) - \(value) }")
}
```  

###### Get/Set index :
 
 Get actual selected index :
```Swift
var index = spinnerBot.selectedIndex
```  

if no selected value :
```Swift
if spinnerBot.selectedIndex == LBZSpinner.INDEX_NOTHING {
    print("NOTHING VALUE")
}
```  

 Set actual selected index :
```Swift
spinnerBot.changeSelectedIndex(1)
```  


## Images example


Example 1 : 

![Img](https://github.com/LeBzul/LBZSpinner/blob/master/example_images/spinner_gray.png)

![Img](https://github.com/LeBzul/LBZSpinner/blob/master/example_images/dropdown_gray.png)

Example 2 : 

![Img](https://github.com/LeBzul/LBZSpinner/blob/master/example_images/spinner_orange.png)

![Img](https://github.com/LeBzul/LBZSpinner/blob/master/example_images/dropdown_orange.png)

Example of dip type  and LeBzul type

![spinner demo](https://github.com/dipkasyap/LBZSpinner/blob/master/example_images/dip_type.png)


## Author

Guillian Drouin, drouingui@gmail.com

Dip kasyap, dpd.ghimire@gmail.com (dip type added)

## License

LBZSpinner is available under the Apache license. See the LICENSE file for more info.
