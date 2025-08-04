

import UIKit

extension NSNotification.Name {
    static let notificationBackCheck = NSNotification.Name("notificationBackCheck")
}


class MainViewController: UIViewController {
    
    
    
    let titleheader : UILabel = {
        let lable = UILabel()
        lable.text = "Title"
        lable.font = .systemFont(ofSize: 19, weight: .medium)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    let descriptionheader : UILabel = {
        let lable = UILabel()
        lable.text = "Description"
        lable.font = .systemFont(ofSize: 19, weight: .medium)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    let titlefield : UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = ""
        view.textAlignment = .left
        view.layer.cornerRadius = 10
        view.textColor = .black
        view.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.2)
        return view
    }()
    
    let descriptionfield : UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = ""
        view.textAlignment = .left
        view.layer.cornerRadius = 10
        view.textColor = .black
        view.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.2)
        return view
    }()

   private lazy var containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var registernotification : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Register Notificationn", for: .normal)
        btn.backgroundColor = .brown
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(checkSettings), for: .touchUpInside)
        return btn
    }()
    
    var notificationId = UUID().uuidString
    
    var notificationTitle : String {
        return titlefield.text
    }
    
    var notificationbodyy : String {
        return descriptionfield.text
    }
    
    
    var selectedDate : Date?
    
    var selectDateLbl : UILabel = {
        let lable = UILabel()
        lable.text = "Set Notification Date And Time"
        lable.font = .systemFont(ofSize: 19, weight: .medium)
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textAlignment = .center
        return lable
    }()
    
    var datePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(didValueChange(sender:)), for: .allEditingEvents)
        return picker
    }()
    
   lazy var dateStack : UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [selectDateLbl,datePicker])
        stackview.axis = .vertical
        stackview.alignment = .center
        stackview.distribution = .fill
       stackview.spacing = 10
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
   

    
    
    var shouldopenSettings : Bool = false
    
    var localManger = notificationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.constructHeader()
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        addToContainer(views: titleheader,descriptionheader,titlefield,descriptionfield,dateStack)
        self.view.addSubview(registernotification)
        viewconstrainnts()
        checkThePremission()
        NotificationCenter.default.addObserver(self, selector: #selector(checkThePremission), name: .notificationBackCheck, object: nil)
        
        let tapgesuture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapgesuture)
        
    }
    
    @objc func didValueChange(sender : UIDatePicker) {
        selectedDate = sender.date
        
       
        
    }
    
     
    
    func viewconstrainnts() {
        
        NSLayoutConstraint.activate([
        
            registernotification.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registernotification.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            registernotification.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            registernotification.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            registernotification.heightAnchor.constraint(equalToConstant: 50),
            
            
            
            
            
            self.containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
        
            titleheader.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 40),
            titleheader.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 15),
            titleheader.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -15),
            
            
            titlefield.topAnchor.constraint(equalTo: self.titleheader.bottomAnchor, constant: 20),
            titlefield.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 15),
            titlefield.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -15),
            
            titlefield.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            descriptionfield.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),

            
            
            descriptionheader.topAnchor.constraint(equalTo: self.titlefield.bottomAnchor, constant: 40),
            descriptionheader.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 15),
            descriptionheader.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -15),
            
            
            descriptionfield.topAnchor.constraint(equalTo: self.descriptionheader.bottomAnchor, constant: 20),
            descriptionfield.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 15),
            descriptionfield.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -15),
            
            self.dateStack.topAnchor.constraint(equalTo: descriptionfield.bottomAnchor, constant: 30),
            dateStack.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 15),
            dateStack.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -15),
            
//            self.datePicker.topAnchor.constraint(equalTo: selectDateLbl.bottomAnchor, constant: 10),
//            datePicker.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 15),
//            datePicker.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -15)
        
        ])
        
       
        
        
    }
    
    
    func addToContainer(views : UIView...) {
        views.forEach { view in
            containerView.addSubview(view)
        }
    }
    
    
    @objc func checkSettings() {
        
        guard !shouldopenSettings else {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                return
            }
            return
        }
        localManger.requestNotificationPremission { premission, error in
            if let e = error {
                print(e.localizedDescription)
            }else {
                if premission {
                    print("premission granted")
                }else {
                    print("premission rejected")
                }
            }
            
            self.checkThePremission()
        }

    }
    
  @objc  func checkThePremission() {
        localManger.checkingPremissionStatus { status in
            DispatchQueue.main.async {
                switch status {
                case .authorize :
                    self.registernotification.isHidden = true
                    self.containerView.isHidden = false
                    self.shouldopenSettings = false
                    break
                case .denied :
                    self.shouldopenSettings = true
                    self.containerView.isHidden = true
                    self.registernotification.isHidden = false
                    break
                case .notDetermined :
                    self.registernotification.isHidden = false
                    self.containerView.isHidden = true
                default :
                    self.registernotification.isHidden = false
                    self.shouldopenSettings = true
                    self.containerView.isHidden = true
                }
            }
        }
    }
    
    func constructHeader() {

        let headertitle = UILabel()
        headertitle.text = "Notification Center"
        headertitle.font = .systemFont(ofSize: 20, weight: .medium)
        headertitle.textAlignment = .left
        headertitle.textColor = .black
        headertitle.translatesAutoresizingMaskIntoConstraints = false
        
 
        let subheader =  UILabel()
            subheader.text = "By Saikumar"
            subheader.font = .systemFont(ofSize: 14, weight: .regular)
           subheader.translatesAutoresizingMaskIntoConstraints = false
            subheader.textColor = .black
            subheader.textAlignment = .left

        let mainStackView = UIStackView(arrangedSubviews: [headertitle,subheader])
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillProportionally
        mainStackView.alignment = .leading
        mainStackView.spacing = 2
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let savebtn =  UIButton()
        savebtn.translatesAutoresizingMaskIntoConstraints = false
        savebtn.setTitle("Save", for: .normal)
        savebtn.setTitleColor(.tintColor, for: .normal)
        savebtn.addTarget(self, action: #selector(scheduleNotification), for: .touchUpInside)

        let containerstack = UIStackView(arrangedSubviews: [mainStackView,savebtn])
        containerstack.axis = .horizontal
        containerstack.distribution = .fill
        containerstack.alignment = .center
        containerstack.translatesAutoresizingMaskIntoConstraints = false
        let titleNav = UIView()
        titleNav.translatesAutoresizingMaskIntoConstraints = false
       
        titleNav.addSubview(containerstack)
        NSLayoutConstraint.activate([
        
            containerstack.topAnchor.constraint(equalTo: titleNav.topAnchor, constant: 0),
            containerstack.bottomAnchor.constraint(equalTo: titleNav.bottomAnchor, constant: 0),
            containerstack.leadingAnchor.constraint(equalTo: titleNav.leadingAnchor, constant: 0),
            containerstack.trailingAnchor.constraint(equalTo: titleNav.trailingAnchor, constant: 0),
            
            titleNav.widthAnchor.constraint(equalToConstant: self.navigationController?.navigationBar.bounds.width ?? 0),
            
            titleNav.heightAnchor.constraint(equalToConstant: self.navigationController?.navigationBar.bounds.height ?? 0)
        
        ])
        self.navigationItem.titleView = titleNav
        
    }
    
    
    @objc func scheduleNotification() {
        
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd"
        let dateVal = date.string(from: selectedDate ?? Date())
        
        
        let minuteDate = DateFormatter()
        minuteDate.dateFormat = "hh:mm a"
        let minute = minuteDate.string(from: selectedDate ?? Date())
        
        let alert = UIAlertController(title: "Reminder", message: "You will get notification on \(dateVal) at \(minute) ", preferredStyle: .alert)
        
        let yesaction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.schedule(notificationId: self.notificationId, notificationname: self.notificationTitle, notificationBody: self.notificationbodyy, notificationDate: self.selectedDate ?? Date())
        }
        
        alert.addAction(yesaction)
        
        self.present(alert, animated: true)
        
    }
    
    
    func schedule(notificationId : String,notificationname : String,notificationBody : String, notificationDate : Date) {
        
        localManger.scheduleNotification(notificationId: self.notificationId, notificationname: notificationname, notificationBody: notificationBody, notificationDate: notificationDate)
        
        
    }
    
    


}




