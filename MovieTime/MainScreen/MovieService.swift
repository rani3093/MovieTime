//
//  MovieService.swift
//  MovieTime
//
//  Created by prasad on 27/11/17.
//  Copyright © 2017 ASA. All rights reserved.
//

import Foundation
class MovieService {
    
    
    typealias SuccessHandler = (_ result: Any?, _ error: ErrorType?)  -> Void
    
    var movieModel = [MovieModel]();
    
    func getMovieList(parameter:String,success:@escaping SuccessHandler)
    {
        
        NetworkCalls().callWS(method: .GET, url: "http://www.omdbapi.com/?s=\(parameter)&apikey=bfce095", params: nil)
        { (response, error) in
            if error != nil
            {
                print(error ?? "");
                return success(nil, ErrorType.No_Internet)
            }
            guard response != nil else
            {
                return success(nil, ErrorType.Something_Went_Wrong)
            }
            print(response ?? "")
            
            self.parseHomeWS(response: response!, success: { (msg, error) in
                success(msg, error)
            })
        }
        
    }
    
    
    func parseHomeWS(response:AnyObject,success:@escaping SuccessHandler)
    {
        
        let resp = response as? NSDictionary
      
        
          if let respo = resp?.object(forKey: "Search") as? NSArray
          {
            movieModel = [MovieModel]();
            for i in respo
            {
                var mModel = MovieModel();
                mModel.title = ((i as! NSDictionary).object(forKey: "Title") as? String)!
                
                mModel.year = ((i as! NSDictionary).object(forKey: "Year") as? String)!
                mModel.id = ((i as! NSDictionary).object(forKey: "imdbID") as? String)!
                
                mModel.poster = ((i as! NSDictionary).object(forKey: "Poster") as? String)!
                movieModel.append(mModel);
                
            }
            success(movieModel, nil)
        }else{
            success("This is Error", ErrorType.webServiceError)
        }
    }
    
    
}
