//
//  Extensions.swift
//  MovieTime
//
//  Created by prasad on 27/11/17.
//  Copyright © 2017 ASA. All rights reserved.
//

import UIKit

extension UIViewController{
    func addStatusBarBG(){
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size:CGSize(width: self.view.frame.width, height:20))
        let view : UIView = UIView.init(frame: rect)
        view.backgroundColor = UIColor.black//UIColor.init(red: 227/255, green: 118/255, blue: 122/255, alpha: 1)
        self.view?.addSubview(view)
        let tintView = UIView.init(frame: rect)
        tintView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        self.view?.addSubview(tintView)
    }
    func showAlert(title:String,message:String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
