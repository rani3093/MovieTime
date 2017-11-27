//
//  ViewController.swift
//  MMovie
//
//  Created by Archana Vetkar on 27/11/17.
//  Copyright © 2017 Archana Vetkar. All rights reserved.
//

//This is the initial screen

import UIKit
import Kingfisher

class ViewController: UIViewController,UITextFieldDelegate {
    
    var mModel = [MovieModel]();
    var activityIndicator: UIActivityIndicatorView?
    private var mPresenter = MoviePresenter(userService:MovieService());
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet var searchView: UIView!
    
    @IBAction func bt_searchBack(_ sender: UIButton) {
        self.searchView.removeFromSuperview();
        mPresenter.GetMovieList();
    }
    
    
    @IBAction func bt_search(_ sender: UIButton) {
    self.searchView.frame=self.topView.frame;
        self.view.addSubview(self.searchView);
        tf_search.delegate=self;
        tf_search.becomeFirstResponder();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil{
        mPresenter.GetMovieList(param: textField.text!)
        }
        self.tf_search.resignFirstResponder();
        return true;
    }
    
    //    MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addStatusBarBG();
        mPresenter.attachView(view: self);
        mPresenter.GetMovieList();
        collectionView.register(UINib(nibName: "mCell", bundle: nil), forCellWithReuseIdentifier: "mCell")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mCell", for: indexPath) as! mCell
        cell.img_movie.kf.setImage(with: URL(string: mModel[indexPath.item].poster!)! , placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil);
        cell.lb_title.text = mModel[indexPath.item].title;
        cell.lb_year.text = mModel[indexPath.item].year;
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mModel.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetail") as! MovieDetail
        vc.selectedMovieId = mModel[indexPath.item].id!;
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/3-20, height: 220)
    }
    
    
}

extension ViewController: DefaultView{
    
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
       // self.mModel.removeAll();
        self.mModel = data as! [MovieModel];
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        self.collectionView.reloadData();
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
