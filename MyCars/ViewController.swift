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

