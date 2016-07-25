//
//  ViewController.swift
//  MyCars


import UIKit
import CoreData

class ViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var lastTimeStartedLabel: UILabel!
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var myChoiceImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    }

    func insertDataFromPlist() {
        let fetchRequest = NSFetchRequest(entityName: "Car")
        fetchRequest.predicate = NSPredicate(format: "mark != nil")

        let count = managedContext.countForFetchRequest( fetchRequest, error: nil)

        guard count == 0 else {return}

        let pathToFile = NSBundle.mainBundle().pathForResource("data", ofType: "plist")
        let daraArray = NSArray(contentsOfFile: pathToFile!)

        for dictionary: AnyObject in daraArray! {
            let entity = NSEntityDescription.entityForName("Car", inManagedObjectContext: managedContext)
            let car = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Car

            let carDict = dictionary as! NSDictionary

            car.mark = carDict["mark"] as! String
            car.model = carDict["model"] as! String
            car.rating = carDict["rating"] as! NSNumber

            let colorDict = carDict["tintcolor"] as! NSDictionary
            car.tintColor = getColor(colorDict)

            let imageName = carDict["imageName"] as! String
            let image = UIImage(named: imageName)
            let imageData = UIImagePNGRepresentation(image!)
            car.imageData = imageData

            car.lastStarted = carDict["lastStarted"] as! NSDate
            car.timesDriven = carDict["timesDriven"] as! NSNumber
            car.myChoice = carDict["myChoice"] as! NSNumber


        }
    }

    func getColor(dict: NSDictionary) -> UIColor {
        let red = dict["red"] as! NSNumber
        let blue = dict["blue"] as! NSNumber
        let green = dict["green"] as! NSNumber

        return UIColor(red: CGFloat(red) / 255, green: CGFloat(blue) / 255, blue: CGFloat(green) / 255, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func segmentedCtrlPressed(sender: UISegmentedControl) {
        
    }
    
    @IBAction func startEnginePressed(sender: UIButton) {
        
    }
    
    @IBAction func rateItPressed(sender: UIButton) {
        
    }
}

