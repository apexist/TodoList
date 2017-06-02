//
//  TaskListViewController.swift
//  Todobox1
//
//  Created by DJV on 2017. 5. 22..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {

    @IBOutlet var editButton : UIBarButtonItem!
    @IBOutlet var doneButton : UIBarButtonItem!
    @IBOutlet var tableView : UITableView!
    
    var tasks : [Task] = [] {
        didSet {
            self.saveAll()
        }
    }
    
    /*
    var tasks : [Task] = [
        Task(title : "청소하기", isDone: false),
        Task(title : "빨래하기", isDone: true),
        Task(title : "이슈 생성하기", isDone: false),
    ]
    //기존 생성자...해치지 않게 Task에서 생성자 만들떄 만들어줘야 한다.
    */

    //view가 메모리에 모두 올라가고 나서 호출됨
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadAll()
    }

    //저장을 해야 함..초기 값을.. userDefault 를 써도됨
    
    
    
    
    /*
     
     TaskListViewController 에서 prepare(for segue…) 는 segue를 통해 viewcontroller가 전환되기 직전에 호출되고, 
     이때 TaskEditViewController에 클로저 타입으로 정의된 didAddTask 변수를 콜백함수로 정의해 주고, 전환된 후, 
     TaskEditViewController 에서 prepare에서 정의된 콜백 클로저를 사용
     
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let vc = nav.viewControllers.first as? TaskEditViewController {
                
                //클로저 정의
                //vc.didAddTask = { (task: Task) -> Void in
                
                //또는 축약
                vc.didAddTask = {task in
                    self.tasks.append(task)
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    
    /// 모든 할일 목록을 UserDefault에 저장
    func saveAll(){
   
        //1. [Task] -> [[String:Any]]    // [String:Any] 딕셔너리 배열이다.
        
        /*
        var array : [[String : Any]] = []
         for task in self.tasks {
            let dictionary = task.toDictionary()
            array.append(dictionary)
         }
         */
        
        //swift 스타일 !!!
    
        let array : [[String:Any]] = self.tasks.map{ $0.toDictionary() } //딕셔너리 배열로 만듬
        
        //2. [[String:Any]] 를 UserDefault에 저장
        
        UserDefaults.standard.set(array, forKey: "tasks") //Cocoa 에서는 value를 넣고 그다음에 key를 넣는다.
        
        //3. UserDefault 동기화
        
        UserDefaults.standard.synchronize() //반드시 실제로 디스크에 저장이 되는것을 보장할 수 있다.
        
    }
    
    
    /// UserDefault에서 할일 목록을 불러옴
    func loadAll(){
        //1. UserDefaults 에서 [[String:Any]] 딕셔녀리 배열을 뽑아옴
        
        //Any?를 반환, 반환된 타입이 없을 수도 있음, 있더라도 딕셔너리 배열이 아닐수 있음, 즉 Any 이므로 형변환 해줘야 함
        let defaults = UserDefaults.standard
        guard let array = defaults.array(forKey: "tasks") as? [[String:Any]] else {return}
        
        //2. [[String:Any]] -> [Task] swift 객체로 갈때 nil 반환될 수 있다. 완벽하다고 할 수 없다. 체크 로직이 꼭 필요
        // for..in or map
        
        /*
        var tasks : [Task] = []
        for dict in array {
            if let task = Task(dictionary: dict) {
                tasks.append(task)
            }
        }
        */
        
        self.tasks = array.flatMap{ Task(dictionary: $0) } // 성공한 것들만 가지고 배열을 만듬
        
        //flatMap : 함수형 언어...
        //[1,2,nil,4,5].flatMap{$0}
        //=> [1,2,4,5]
        

    }
    
// MARK : Actions
    
    @IBAction func editButtonDidSelect(){
        //선택하면 Edit - Done 사이에 버튼을 바꾸어준다.
        self.navigationItem.leftBarButtonItem = self.doneButton //navigationItem 은 left,right, title 등 지정할 수 있다.
        //self.tableView.isEditing = true //edit 버튼 눌렀을때 에미네이션 효과가 있다.
        
        //cell을 에디팅 가능하도록 셋팅한다.
        self.tableView.setEditing(true, animated: true)
        //Add button 비활성화
        
        
        //obj-c 에서는 [self.tableView setEditing:true];
    }
    
    @IBAction func doneButtonDidSelect(){
        self.navigationItem.leftBarButtonItem = self.editButton
         self.tableView.setEditing(false, animated: true)
    }

}



// MARK: - UITableViewDataSource
extension TaskListViewController: UITableViewDataSource{
    
    //아래 두개의 함수는 tableviewdatasource프로토콜을 사용했을때 반드시 생성되어야 하는 함수다
    
    //섹션 내 row의 갯수를 리턴하는 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //return 100
        return tasks.count
    }
    
    //셀의 내용을 리턴하는 함수
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //            let cell = UITableViewCell()// 매번 스크롤때마다 새로운 인스턴스가 생김
        //동시에 최대 보일수 있는거 만들어놓고, 새로 보이는 편에 다시 사용 재활용한다.
        //셀을 재사용 가능한 풀에 만들어놓고 꺼내와서 재활용하는 방식
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        let task = tasks[indexPath.row]
        
        cell.textLabel?.text = task.title
        
        cell.detailTextLabel?.text = task.memo
        
        if task.isDone {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none //반드시 정의 해줘야 함.. 안그러면 cell이 재사용 되면서, 기존에 정의된 cell이 똑같이 체크된 채로 보임
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate 
//셀의 행동이나 크기를 정의 할때

extension TaskListViewController : UITableViewDelegate {
//will did 등....행위 시기를 정의
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let oldTask = self.tasks[indexPath.row]
        
        print("oldTask : \(oldTask)")
        
        let newTask = Task(title: oldTask.title, isDone: !oldTask.isDone, memo : oldTask.memo)
        self.tasks[indexPath.row] =  newTask
        
        print("updated tasks \(tasks)")
        
        //tableview에게 알려줘야 함, 애니메이션 효과넣을때
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        //다른 방법 , 애니메이션 없이
        //tableView.reloadData()
    }
    
    //delete 관련된 함수
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        //self.tableView.reloadData()
    }
    
    //순서 바꿀때, 순서바뀐걸 저장해야 한다.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //let task = self.tasks[sourceIndexPath.row]
        //self.tasks.remove(at: sourceIndexPath.row)
        
        //or
        
        let task = self.tasks.remove(at: sourceIndexPath.row)
        self.tasks.insert(task, at: destinationIndexPath.row)
        
        
    }
    
    
}

