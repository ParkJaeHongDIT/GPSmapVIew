import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var contents = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        self.title = "중간고사 201753005 박재홍"
        
        // Add.plist의 데이터를 로드
        let path = Bundle.main.path(forResource: "Add", ofType: "plist")
        contents = NSArray(contentsOfFile: path!)!
        
    }
    
    //row의 갯수를 카운트
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    //Add.plist의 title과 address의 값을 테이블 뷰 셀에 삽입
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let myTitle = (contents[indexPath.row] as AnyObject).value(forKey: "title")
        let myAddress = (contents[indexPath.row] as AnyObject).value(forKey: "address")
        
        
        print(myAddress!)
        
        myCell.textLabel?.text = myTitle as? String
        myCell.detailTextLabel?.text = myAddress as? String
        
        return myCell
    }
    
    //Add.plist의 위치정보 데이터를 DetailMapViewController에 전달, 아닐경우엔   TotalMapViewController로 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetail" {
            
            let detailMVC = segue.destination as! DetailMapViewController
            let selectedPath = myTableView.indexPathForSelectedRow
            
            let myIndexedTitle = (contents[(selectedPath?.row)!] as AnyObject).value(forKey: "title")
            let myIndexedAddress = (contents[(selectedPath?.row)!] as AnyObject).value(forKey: "address")
            
            print("myIndexedTitle = \(String(describing: myIndexedTitle))")
            
            detailMVC.dTitle = myIndexedTitle as? String
            detailMVC.dAddress = myIndexedAddress as? String
            
        } else if segue.identifier == "goTotalMap" {
            print("this is TotalMapViewController")
            
            let totalMVC = segue.destination as! TotalMapViewController
            totalMVC.dContents = contents
            
        }
    }
    
    
}
