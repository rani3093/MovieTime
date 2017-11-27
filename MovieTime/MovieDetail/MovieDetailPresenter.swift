//
//  MovieDetailPresenter.swift
//  MovieTime
//
//  Created by prasad on 27/11/17.
//  Copyright © 2017 ASA. All rights reserved.
//

import Foundation
class MovieDetailPresenter
{
    
    private let userService : MovieDetailService
    weak private var userView : DefaultView?
    
    
    init(userService:MovieDetailService)
    {
        self.userService = userService
    }
    
    func attachView(view:DefaultView)
    {
        userView = view
        
    }
    
    func dittachView()
    {
        userView=nil;
    }
    
    
    //MARK:- Forgot password
    
    func GetMovieList(param:String)
    {
        self.userView?.startLoading()
        userService.getMovieDetail(parameter: param) { (data, error) in
            if error != nil{
                if error == ErrorType.No_Internet{
                    self.userView?.showError(title: "", msg: "Please check your internet connection")
                }else if error == ErrorType.Something_Went_Wrong{
                    self.userView?.showError(title: "", msg: "Oops! Something went wrong!")
                }else if error == ErrorType.webServiceError{
                    self.userView?.showError(title: "", msg: data as! String)
                }else if error == ErrorType.validationError{
                    self.userView?.showError(title: "", msg: data as! String)
                }
                self.userView?.finishLoading();
                return;
                
            }
            self.userView?.setData(data: data ?? "");
            self.userView?.finishLoading();
        }
    }
    
    
    
}
