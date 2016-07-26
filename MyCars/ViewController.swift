//
//  ViewController.swift
//  MyCars


import UIKit
import CoreData

class ViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
    var selectedCar: Car!
    
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

        insertDataFromPlist()
        let request = NSFetchRequest(entityName: "Car")
        let mark = segmentedControl.titleForSegmentAtIndex(0)

        request.predicate = NSPredicate(format: "mark == %@", mark!)

        do {
            let results = try managedContext.executeFetchRequest(request) as! [Car]
            selectedCar = results.first
            insertDataFrom(selectedCar)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }


    }

    func insertDataFrom(car: Car) {
        carImageView.image = UIImage(data: car.imageData!)
        modelLabel.text = car.model
        markLabel.text = car.mark
        ratingLabel.text = "Rating: \(car.rating!.doubleValue) / 10.0"
        numberOfTripsLabel.text = "times driven: \(car.timesDriven!.integerValue)"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
        lastTimeStartedLabel.text = "Last started: " + dateFormatter.stringFromDate(car.lastStarted!)
        myChoiceImageView.hidden = !car.myChoice!.boolValue
        view.tintColor = car.tintColor as! UIColor



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

            car.mark = carDict["mark"] as? String
            car.model = carDict["model"] as? String
            car.rating = carDict["rating"] as? NSNumber

            let colorDict = carDict["tintColor"] as? NSDictionary
            car.tintColor = getColor(colorDict!)

            let imageName = carDict["imageName"] as? String
            let image = UIImage(named: imageName!)
            let imageData = UIImagePNGRepresentation(image!)
            car.imageData = imageData

            car.lastStarted = carDict["lastStarted"] as? NSDate
            car.timesDriven = carDict["timesDriven"] as? NSNumber
            car.myChoice = carDict["myChoice"] as? NSNumber

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
        let timesDriven = selectedCar.timesDriven?.integerValue
        selectedCar.timesDriven = NSNumber(integer: (timesDriven! + 1))

        selectedCar.lastStarted = NSDate()

        do {
            try managedContext.save()
            insertDataFrom(selectedCar)
        } catch let error as NSError {
            print("Save timesDriven and lastStarted error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func rateItPressed(sender: UIButton) {
        let alert = UIAlertController(title: "Rate it", message: "Rate this car", preferredStyle: .Alert)
        let rateAction = UIAlertAction(title: "Rate", style: .Default) { (action: UIAlertAction) in
            let textField = alert.textFields?.first
            self.updateRating((textField?.text)!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) in

        }
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            textField.keyboardType = .NumberPad
        }
        alert.addAction(rateAction)
        alert.addAction(cancelAction)

        presentViewController(alert, animated: true, completion: nil)
    }

    func updateRating(string: String) {
        selectedCar.rating = (string as NSString).doubleValue

        do {
            try managedContext.save()
            insertDataFrom(selectedCar)
        } catch let error as NSError {
            let alert = UIAlertController(title: "Wrong", message: "Value is not from 0 to 10", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "ok", style: .Default, handler: nil)
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
            print("Rating save error: \(error.localizedDescription)")
        }
    }
}

