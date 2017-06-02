//
//  Task.swift
//  Todobox1
//
//  Created by DJV on 2017. 5. 24..
//  Copyright © 2017년 Junghoon Lee. All rights reserved.
//

//구조체는 pure swift이기 때문에 foundation이 필요없음
//import Foundation

//미션
//Task라는 struct를 만들자
//title : String
//isDone : Bool

struct Task {
    
    // let을 사용할 수 있을때는 무조건 let을 사용한다.
    // struct 복제를 한후 바뀌는 값만 바꾸면 된다. 그럴 값만 var로 사용한다.
    
    let title : String
    var isDone : Bool
    let memo : String?
    
    
    
    init(title : String, isDone : Bool, memo: String? = nil){
        self.title = title
        self.isDone = isDone //self를 꼭 붙여야 함. 안그럼 어떤 위의 값인지 구분이 안됨
        self.memo = memo
    }
    
    ///Task -> Dictionary , user default 에 저장 위해 , 이렇게 ///하면 옵션키와 조합해서 보면 보인다. 커멘트 , 딕셔너리로 만들어서 저장
    func toDictionary() -> [String: Any] {
        var dict : [String:Any] = [
            "title" : title,
            "isDone" : isDone, //여기에 ,를 찍어두면 diff 변화가 아래 추가 됐을 때 하나만 생성 된다. (꿀팁)
        ]
        
        if let memo = self.memo {
            dict["memo"] = memo
        }
        return dict
    }
    
    
    ///Dictionary -> Task, 저장된걸 꺼내서 task로 만듬
    
    init?(dictionary : [String:Any]) { //? 붙은 생성자는 nil을 반환할 수 있다. 조건에 맞지 않는 경우에 인스턴스 생성 실패하고 nil반환
        guard let title = dictionary["title"] as? String else {return nil}
        self.title = title
        
        guard let isDone = dictionary["isDone"] as? Bool else {return nil}
        self.isDone = isDone
        
        self.memo = dictionary["memo"] as? String
        
    }
    
    
}


//Task를 딕셔녀리 만들어야 함
