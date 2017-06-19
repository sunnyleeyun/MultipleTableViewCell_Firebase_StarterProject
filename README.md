# Firebase: 實作 Multiple Tableview Cell 教學

[id1]: http://sunnylee945.wixsite.com/leeyun/single-post/2017/02/21/Firebase%EF%BC%9A%E7%94%A8-Swift-%E5%BB%BA%E7%AB%8B%E3%80%8C%E8%A8%BB%E5%86%8A%E3%80%8D%E7%B3%BB%E7%B5%B1
[id2]: https://github.com/sunnyleeyun/MultipleTableviewCellFirebase/archive/master.zip


## 這是 Starter Project，若要完整版請 [點此][id2] 下載 ####



#### Demo ####
[![Demo](https://i.ytimg.com/vi/htfrnydH9Kg/1.jpg?time=1497861815165)](https://youtu.be/htfrnydH9Kg)




### 註：Firebase與App的連結，請至[ Firebase : 用Swift建立註冊系統 ][id1]，「步驟二」有詳盡步驟，以下只有單純就程式碼進行解釋喔！ ###
---------------------------------------
## Pod ##

```
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod ‘Firebase/Storage’
```

---------------------------------------

## AppDelegate ##
```
import UIKit
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FIRApp.configure()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


```


---------------------------------------

## InitialViewController ##
```
import UIKit
import FirebaseDatabase
import FirebaseAuth

class InitialViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passsword: UITextField!
    
    var uid = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = FIRAuth.auth()?.currentUser {
            uid = user.uid
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logIn(_ sender: Any) {
        
        if self.email.text != "" || self.passsword.text != ""{
            
            FIRAuth.auth()?.signIn(withEmail: self.email.text!, password: self.passsword.text!, completion: { (user, error) in
                
                if error == nil {
                    if let user = FIRAuth.auth()?.currentUser{
                        self.uid = user.uid
                    }
                    
                    FIRDatabase.database().reference(withPath: "Online-Status/\(self.uid)").setValue("ON")
                    
                    self.doneLogIn()
                }
                
            })
        }
        
    }

    @IBAction func signUp(_ sender: Any) {
        if self.email.text != "" || self.passsword.text != ""{
            
            FIRAuth.auth()?.createUser(withEmail: self.email.text!, password: self.passsword.text!, completion: { (user, error) in
                
                if error == nil {
                    if let user = FIRAuth.auth()?.currentUser{
                        
                        self.uid = user.uid
                        
                    }
                    
                    
                    FIRDatabase.database().reference(withPath: "ID/\(self.uid)/Profile/Safety-Check").setValue("ON")
                    FIRDatabase.database().reference(withPath: "Online-Status/\(self.uid)").setValue("ON")

                    self.doneSignUp()
                    
                    }
                
            })
        }
    }
    
    func doneLogIn(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "MainNavigationID") as! UINavigationController
        
        self.present(nextVC,animated:true,completion:nil)
        
    }
    
    func doneSignUp(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewControllerID")as! SignUpViewController
        self.present(nextVC,animated:true,completion:nil)
        

    }
    

}

```


---------------------------------------

## SignUpViewController ##
```

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var cookName: UITextField!
    
    @IBOutlet weak var foodName: UITextField!
    
    @IBOutlet weak var cookTime: UITextField!
    
    @IBOutlet weak var howCook: UITextView!
    
    var uid = ""
    
    // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
    let uniqueString = NSUUID().uuidString

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let user = FIRAuth.auth()?.currentUser {
            uid = user.uid
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func done(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "MainNavigationID") as! UINavigationController
        self.present(nextVC,animated:true,completion:nil)
    }
    
    @IBAction func confirm(_ sender: Any) {
        
        if cookName.text != "" && foodName.text != "" && cookTime.text != "" && howCook.text != ""{
            
            FIRDatabase.database().reference(withPath: "Meal/\(self.uniqueString)").child("FoodName").setValue(foodName.text!)
            FIRDatabase.database().reference(withPath: "Meal/\(self.uniqueString)").child("cookTime").setValue(cookTime.text!)
            FIRDatabase.database().reference(withPath: "Meal/\(self.uniqueString)").child("cookName").setValue(cookName.text!)
            FIRDatabase.database().reference(withPath: "Meal/\(self.uniqueString)").child("cookhow").setValue(howCook.text!)
            
            done()
        
        
        }
    }
    
    
    @IBAction func addImage(_ sender: Any) {
        
         
        // 建立一個 UIImagePickerController 的實體
        let imagePickerController = UIImagePickerController()
        
        // 委任代理
        imagePickerController.delegate = self
        
        // 建立一個 UIAlertController 的實體
        // 設定 UIAlertController 的標題與樣式為 動作清單 (actionSheet)
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
        
        // 建立三個 UIAlertAction 的實體
        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
            
            // 判斷是否可以從照片圖庫取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (Void) in
            
            // 判斷是否可以從相機取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.camera)，並 present UIImagePickerController
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
            
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        
        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(imagePickerAlertController, animated: true, completion: nil)
        
 

        
    }
    

    
}


extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage
        }
        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        
        
        if let user = FIRAuth.auth()?.currentUser {
            uid = user.uid
            
            
            // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
            if let selectedImage = selectedImageFromPicker {
                
                
                let storageRef = FIRStorage.storage().reference().child("\(uniqueString).png")
                
                if let uploadData = UIImagePNGRepresentation(selectedImage) {
                    // 這行就是 FirebaseStorage 關鍵的存取方法。
                    storageRef.put(uploadData, metadata: nil, completion: { (data, error) in
                        
                        if error != nil {
                            
                            // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                            print("Error: \(error!.localizedDescription)")
                            return
                        }
                        
                        // 連結取得方式就是：data?.downloadURL()?.absoluteString。
                        if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                            
                            // 我們可以 print 出來看看這個連結事不是我們剛剛所上傳的照片。
                            print("Photo Url: \(uploadImageUrl)")
                            
                            
                            //let databaseRef = FIRDatabase.database().reference(withPath: "User/\(self.uid)/Profile/Verification").child(uniqueString)
                            let databaseRef = FIRDatabase.database().reference(withPath: "Meal/\(self.uniqueString)").child("cookPic")
                            
                            databaseRef.setValue(uploadImageUrl, withCompletionBlock: { (error, dataRef) in
                                
                                if error != nil {
                                    
                                    print("Database Error: \(error!.localizedDescription)")
                                }
                                else {
                                    
                                    print("圖片已儲存")
                                }
                                
                            })
                            
                            
                        }
                    })
                }
            }
            dismiss(animated: true, completion: nil)
            
            
        }//uid
        
        
    }
    
    
}



```

---------------------------------------

## MainTableViewController ##
```

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class MainTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var DishesTableView: UITableView!
    var uid = ""
    
    var refHandle: UInt!
    var databaseRef: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    
    var mealList = [Meals]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DishesTableView.delegate = self
        DishesTableView.dataSource = self
        
        if let user = FIRAuth.auth()?.currentUser {
            uid = user.uid
        }
        

        let rightButtonItem = UIBarButtonItem.init(
            title: "新增",
            style: .done,
            target: self,
            action: #selector(done)
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
      
        
        databaseRef = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference()
        
        

        fetchMealsList()


    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func done(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "DishesViewControllerID") as! DishesViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func fetchMealsList(){
        
        refHandle = databaseRef.child("Meal").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : AnyObject]{
                print("dictionary is \(dictionary)")
                
                let mealDetail = Meals()
                
                mealDetail.setValuesForKeys(dictionary)
                self.mealList.append(mealDetail)
                
                DispatchQueue.main.async {
                    self.DishesTableView.reloadData()
                }
                
            }
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DishesTableViewCell
        cell.cookNameMeal.text = mealList[indexPath.row].cookName
        cell.nameMeal.text = mealList[indexPath.row].FoodName
        cell.timeMeal.text = mealList[indexPath.row].cookTime
        
        if let profileImageUrl = mealList[indexPath.row].cookPic{
            let url = URL(string: profileImageUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil{
                    print(error)
                    return
                }
                
                DispatchQueue.main.async {
                    cell.imageMeal.image = UIImage(data: data!)
                }
                
            }).resume()
            
        }
        
        cell.cookHowMeal.text = mealList[indexPath.row].cookhow
        

        
        return cell
    }
    

}


```

---------------------------------------

## Meals ##
```
import UIKit

class Meals: NSObject{
    
    var FoodName: String?
    var cookTime: String?
    
    var cookPic: String?
    
    var cookhow: String?
    var cookName: String?
    
}

```

---------------------------------------

## DishesTableViewCell ##
```
import UIKit

class DishesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameMeal: UILabel!
    
    @IBOutlet weak var timeMeal: UILabel!
    
    @IBOutlet weak var imageMeal: UIImageView!
    
    @IBOutlet weak var cookNameMeal: UILabel!
    
    @IBOutlet weak var cookHowMeal: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
```
---------------------------------------

## DishesViewController ##
```
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DishesViewController: UIViewController {

    @IBOutlet weak var cookName: UITextField!
    
    @IBOutlet weak var foodName: UITextField!
    
    @IBOutlet weak var cookTime: UITextField!
    
    @IBOutlet weak var cookHow: UITextView!
    
    
    var uid = ""
    
    let uniqueString = NSUUID().uuidString

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        if let user = FIRAuth.auth()?.currentUser {
            uid = user.uid
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func done(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "MainNavigationID") as! UINavigationController
        self.present(nextVC,animated:true,completion:nil)
        
    }
    
    @IBAction func confirm(_ sender: Any) {
        
        if cookName.text != "" && foodName.text != "" && cookTime.text != "" && cookHow.text != ""{
        
            
            FIRDatabase.database().reference(withPath: "Meal/\(self.uniqueString)").child("FoodName").setValue(foodName.text!)
            FIRDatabase.database().reference(withPath: "Meal/\(self.uniqueString)").child("cookTime").setValue(cookTime.text!)
            FIRDatabase.database().reference(withPath: "Meal/\(self.uniqueString)").child("cookName").setValue(cookName.text!)
            FIRDatabase.database().reference(withPath: "Meal/\(self.uniqueString)").child("cookhow").setValue(cookHow.text!)
            
            
            done()
        }
        
    }
    
    @IBAction func addImage(_ sender: Any) {
        
        
        
        // 建立一個 UIImagePickerController 的實體
        let imagePickerController = UIImagePickerController()
        
        // 委任代理
        imagePickerController.delegate = self
        
        // 建立一個 UIAlertController 的實體
        // 設定 UIAlertController 的標題與樣式為 動作清單 (actionSheet)
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
        
        // 建立三個 UIAlertAction 的實體
        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
            
            // 判斷是否可以從照片圖庫取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (Void) in
            
            // 判斷是否可以從相機取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.camera)，並 present UIImagePickerController
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
            
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        
        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(imagePickerAlertController, animated: true, completion: nil)
        
        
        
        
    }
    

}


extension DishesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage
        }
        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        
        
        if let user = FIRAuth.auth()?.currentUser {
            uid = user.uid
            
            
            // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
            if let selectedImage = selectedImageFromPicker {
                
                
                let storageRef = FIRStorage.storage().reference().child("\(uniqueString).png")
                
                if let uploadData = UIImagePNGRepresentation(selectedImage) {
                    // 這行就是 FirebaseStorage 關鍵的存取方法。
                    storageRef.put(uploadData, metadata: nil, completion: { (data, error) in
                        
                        if error != nil {
                            
                            // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                            print("Error: \(error!.localizedDescription)")
                            return
                        }
                        
                        // 連結取得方式就是：data?.downloadURL()?.absoluteString。
                        if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                            
                            // 我們可以 print 出來看看這個連結事不是我們剛剛所上傳的照片。
                            print("Photo Url: \(uploadImageUrl)")
                            
                            
                            
                            let databaseRef = FIRDatabase.database().reference(withPath: "Meal/\(self.uniqueString)").child("cookPic")
                            
                            databaseRef.setValue(uploadImageUrl, withCompletionBlock: { (error, dataRef) in
                                
                                if error != nil {
                                    
                                    print("Database Error: \(error!.localizedDescription)")
                                }
                                else {
                                    
                                    print("圖片已儲存")
                                }
                                
                            })
                            
                            
                        }
                    })
                }
            }
            dismiss(animated: true, completion: nil)
            
            
        }//uid
        
        
    }
 
    
}
 

```
---------------------------------------

### 如果需要完整版 ( 無任何備註 ) ，請[點此][id2]開始下載。

