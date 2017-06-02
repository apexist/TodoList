import UIKit

class TaskEditViewController : UIViewController{
    
    @IBOutlet var textField : UITextField!
    @IBOutlet var textView : UITextView!
    
    //클로저는 변수처럼 정의 할 수 있다.
    //let hello : ((String, String) -> String) = { $1 + $0 + "님 안녕하세요" }
    //hello("정훈", "이")
    var didAddTask : ((Task) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //테두리를 지정
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1 / UIScreen.main.scale // 1 인경우보다 얇게 만들어야 한다. 1 / scale 해야 함, 물리픽셀한개만 쓰는 선을 얻을 수 있다. hairline으로 주세요.. 1픽셀로 그려져야 하는것
        textView.layer.cornerRadius = 5
    }
    
    @IBAction func cancelButtonDidTap() {
        textField.resignFirstResponder()

        //캔슬 시 사용자 경험을 확대
        //UIAlertController (IOS8 부터)
        //팝업으로 뜨는건 alert 과 아래에서 올라오는건 actionsheet (..., .alert  / .actionSheet)
        
        //isEmpty : true , false, nil
        if textField.text?.isEmpty == false {
            
            let alertController = UIAlertController(
                title: "정말 닫으실 건가요?",
                message: "내용이 유실될 수 있습니다.",
                //preferredStyle: UIAlertControllerStyle.alert //스타일 결정
                preferredStyle: .alert //스타일 결정
            )
            
            let deleteAction = UIAlertAction(title : "작성 취소", style : .destructive) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "계속 작성", style: .cancel) { _ in
                //키보드가 계속 보이게
                self.textField.becomeFirstResponder()
            }
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion : nil)
            
        }else{
        
            self.dismiss(animated: true, completion: nil)
            
        }
        
        
    }
    
    @IBAction func doneButtonDidTap() {
        
        //guard : 함수의 시작부분에 써서 반드시 가져가야할 조건을 검사한다. if로 나열하는 것보다 가독성이 좋다.
        //
        guard let title = textField.text , !title.isEmpty else {
            shakeTextField()
            return }
            
            
            
        let task = Task(title: title, isDone: false, memo: textView.text)
        
            //어떻게 TaskListViewController에 전달 할 것인가?
            //클로저를 활용한 콜백을 쓴다.
            
            didAddTask?(task)
            textField.resignFirstResponder()
            self.dismiss(animated: true, completion: nil)
            
            /*
            //아래는 작동은 하지만 쓰지 말아야 한다.
            if let nav = self.presentingViewController as? UINavigationController{
                if let vc = nav.viewControllers.first as? TaskListViewController {
                    vc.tasks.append(task)
                    vc.tableView.reloadData()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            */
        }
    
    func shakeTextField() {
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.textField.frame.origin.x += 10
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.1,
                    animations: {
                        self.textField.frame.origin.x -= 10
                    },
                    completion: { _ in
                        UIView.animate(
                            withDuration: 0.1,
                            animations: {
                                self.textField.frame.origin.x += 10
                            },
                            completion: { _ in
                                UIView.animate(
                                    withDuration: 0.1,
                                    animations: {
                                        self.textField.frame.origin.x -= 10
                                    },
                                    completion: { _ in
                                    }
                                )
                            }
                        )
                    }
                )
            }
        )
    }
    
    }
    
