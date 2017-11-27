//
//  MovieDetail.swift
//  MMovie
//
//  Created by Archana Vetkar on 27/11/17.
//  Copyright © 2017 Archana Vetkar. All rights reserved.
//

import UIKit

class MovieDetail: UIViewController {
    
    @IBOutlet weak var img_movie: UIImageView!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_year: UILabel!
    @IBOutlet weak var lb_rating: UILabel!
    
    @IBOutlet weak var tv_desc_cast: UITextView!
    
    @IBOutlet weak var lb_description: UILabel!
    @IBOutlet weak var lb_cast: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    var selectedMovieId = String();
    var mModel = MovieModel();
    var activityIndicator: UIActivityIndicatorView?
    private var mdPresenter = MovieDetailPresenter(userService:MovieDetailService());
    
    @IBAction func bt_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true);
    }
    
    override func viewDidLoad() {
        self.addStatusBarBG();
        
        mdPresenter.attachView(view: self)
        mdPresenter.GetMovieList(param: selectedMovieId);
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.blue.withAlphaComponent(0.4), UIColor.black.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.bgView.layer.insertSublayer(gradient, at: 0)
    }
    
}
extension MovieDetail : DefaultView{

    func startLoading() {
        DispatchQueue.main.async{
            self.activityIndicator = UIActivityIndicatorView();
            self.activityIndicator?.color = UIColor.white;
            self.activityIndicator?.activityIndicatorViewStyle = .whiteLarge;
            self.activityIndicator?.frame = CGRect(x: 50, y: 50, width: 30, height: 30);
            self.activityIndicator?.center = self.view.center;
            self.activityIndicator?.startAnimating();
            self.activityIndicator?.hidesWhenStopped=true
            self.view.addSubview((self.activityIndicator)!);
        }
    }
    
    func finishLoading() {
        DispatchQueue.main.async{
            self.activityIndicator?.stopAnimating();
        }
    }
    
    func setData(data: Any) {
        DispatchQueue.main.async
            {
                self.mModel = data as! MovieModel;
                self.img_movie.kf.setImage(with: URL(string: self.mModel.poster!)! , placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil);
                self.lb_title.text = self.mModel.title;
                self.lb_year.text = self.mModel.year
                self.lb_rating.text = "Rating: "+self.mModel.rating!;
                self.tv_desc_cast.text = self.mModel.storyline! + "\n\nCast: " + self.mModel.cast!
//                self.lb_cast.text = self.mModel.cast;
//                self.lb_description.text = self.mModel.storyline;
                
        }
    }
    
    func showError(title: String, msg message: String) {
        self.showAlert(title: "", message: message);
    }
    
    func setEmptyData() {
        
    }
    func showErrorImage() {
        
    }
    func showNoInternetImage() {
        
    }
    
    
}
