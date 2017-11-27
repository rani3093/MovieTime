//
//  MovieDetailService.swift
//  MovieTime
//
//  Created by prasad on 27/11/17.
//  Copyright © 2017 ASA. All rights reserved.
//

import Foundation
class MovieDetailService {
    
    typealias SuccessHandler = (_ result: Any?, _ error: ErrorType?)  -> Void
    
    var mModel = MovieModel();
    
    func getMovieDetail(parameter:String,success:@escaping SuccessHandler)
    {
        
        NetworkCalls().callWS(method: .GET, url: "http://www.omdbapi.com/?i=\(parameter)&apikey=bfce095", params: nil)
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
            
            self.parseWS(response: response!, success: { (msg, error) in
                success(msg, error)
            })
        }
        
    }
    
    
    func parseWS(response:AnyObject,success:@escaping SuccessHandler)
    {
        
        if let resp = response as? NSDictionary
        {
            mModel = MovieModel();
            mModel.title = (resp.object(forKey: "Title") as? String)!
            
            mModel.year = (resp.object(forKey: "Year") as? String)!
            mModel.cast = (resp.object(forKey: "Actors") as? String)!
            mModel.poster = (resp.object(forKey: "Poster") as? String)!
            mModel.rating = (resp.object(forKey: "imdbRating") as? String)!
            mModel.storyline = (resp.object(forKey: "Plot") as? String)!
            
            
            
            success(mModel, nil)
        }else{
            success("This is Error", ErrorType.webServiceError)
        }
    }
    
    
}
