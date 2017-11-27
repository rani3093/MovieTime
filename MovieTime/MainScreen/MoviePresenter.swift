//
//  MoviePresenter.swift
//  MovieTime
//
//  Created by prasad on 27/11/17.
//  Copyright © 2017 ASA. All rights reserved.
//

import Foundation
class MoviePresenter
{
    
    private let userService : MovieService
    weak private var userView : DefaultView?
    
    
    init(userService:MovieService)
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
    
    
    //to get the initial list I am hardcoding it with "MR"
    func GetMovieList(param:String="mr")
    {
        self.userView?.startLoading()
        userService.getMovieList(parameter: param) { (data, error) in
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
