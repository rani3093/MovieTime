//
//  MovieModel.swift
//  MovieTime
//
//  Created by prasad on 27/11/17.
//  Copyright © 2017 ASA. All rights reserved.
//

import Foundation
struct MovieModel {
    var poster : String?
    var cast : String?
    var rating : String?
    var title : String?
    var id : String?
    var year : String?
    var storyline : String?
}
protocol DefaultView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setData(data:Any)
    func showError(title:String,msg:String)
    func setEmptyData()
    func showErrorImage()
    func showNoInternetImage()
}
