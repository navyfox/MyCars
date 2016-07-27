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
        //подгружаем только для segmentedControl с 0 индексом при загрузке приложения
        let request = NSFetchRequest(entityName: "Car")
        let mark = segmentedControl.titleForSegmentAtIndex(1)

        request.predicate = NSPredicate(format: "mark == %@", mark!)

        do {
            let results = try managedContext.executeFetchRequest(request) as! [Car]
            selectedCar = results.first
            insertDataFrom(selectedCar)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }


    }
//обновляем ярлыки в зависимости от машины
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

//извлекаем все данные из файла data.plist в entity Car
    func insertDataFromPlist() {
        //делаем запрос на получение из CoreData обьектов с филтром где mark != nil
        let fetchRequest = NSFetchRequest(entityName: "Car")
        fetchRequest.predicate = NSPredicate(format: "mark != nil")
//проверяем сколько обьектов мы получили, если они есть то выходим из func
        let count = managedContext.countForFetchRequest( fetchRequest, error: nil)
        guard count == 0 else {return}
//создаем путь для файла, затем все что извлекается закидываем в массив
        let pathToFile = NSBundle.mainBundle().pathForResource("data", ofType: "plist")
        let daraArray = NSArray(contentsOfFile: pathToFile!)
//пребираем наш масив словарей в качастве AnyObject
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
    
    
    @IBAction func segmentedCtrlPressed(segCtrl: UISegmentedControl) {
//создаем заголовок по segCtrl
        let selectedTitle = segCtrl.titleForSegmentAtIndex(segCtrl.selectedSegmentIndex)
//создаем запрос и отбираем по заголовку
        let fetchRequest = NSFetchRequest(entityName: "Car")
        fetchRequest.predicate = NSPredicate(format: "mark == %@", selectedTitle!)
//пытаемся созранить и обновить или ошибку выводим
        do {
            //сохраняем результат в конкретный selectedCar
            let result = try managedContext.executeFetchRequest(fetchRequest) as! [Car]
            selectedCar = result.first
            //меняем ярлыки
            insertDataFrom(selectedCar)
        }catch let error as NSError {
            print("Can't perform request: \(error.localizedDescription)")
        }
    }
    
    @IBAction func startEnginePressed(sender: UIButton) {
//извлекаем количество запусков и меняем
        let timesDriven = selectedCar.timesDriven?.integerValue
        selectedCar.timesDriven = NSNumber(integer: (timesDriven! + 1))
//меняем дату запуска
        selectedCar.lastStarted = NSDate()
//пытаемся созранить и обновить или ошибку выводим
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
//пытаемся созранить и обновить или ошибку выводим
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

