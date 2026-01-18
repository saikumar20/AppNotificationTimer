import UIKit

extension NSNotification.Name {
    static let notificationBackCheck = NSNotification.Name("notificationBackCheck")
}

class MainViewController: UIViewController {
    

    private let notificationManager = NotificationManager.shared
    private var notificationId = UUID().uuidString
    private var selectedDate: Date?
    private var shouldOpenSettings = false
    

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.textColor = .label
        textView.backgroundColor = .secondarySystemBackground
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.textColor = .label
        textView.backgroundColor = .secondarySystemBackground
        textView.font = .systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()
    
    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Set Notification"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.minimumDate = Date()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateTimeLabel, datePicker])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Enable Notifications", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupConstraints()
        setupGestureRecognizers()
        checkPermission()
        setupNotificationObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
 
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleTextView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(dateStackView)
        
        view.addSubview(registerButton)
    }
    
    private func setupNavigationBar() {
        let headerLabel = UILabel()
        headerLabel.text = "Notification Center"
        headerLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        headerLabel.textColor = .label
        
        let subHeaderLabel = UILabel()
        subHeaderLabel.text = "By Saikumar"
        subHeaderLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subHeaderLabel.textColor = .secondaryLabel
        
        let headerStack = UIStackView(arrangedSubviews: [headerLabel, subHeaderLabel])
        headerStack.axis = .vertical
        headerStack.alignment = .leading
        headerStack.spacing = 2
        
        let saveButton = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: headerStack)
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
      
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
      
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
      
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            

            titleTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleTextView.heightAnchor.constraint(equalToConstant: 80),
            
    
            descriptionLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
   
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
            
 
            dateStackView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            dateStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            

            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkPermission),
            name: .notificationBackCheck,
            object: nil
        )
    }
    
  
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    @objc private func registerButtonTapped() {
        guard !shouldOpenSettings else {
            openSettings()
            return
        }
        
        notificationManager.requestNotificationPermission { [weak self] granted, error in
            if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
            }
            self?.checkPermission()
        }
    }
    
    @objc private func saveButtonTapped() {
        scheduleNotification()
    }
    
  
    @objc private func checkPermission() {
        notificationManager.checkPermissionStatus { [weak self] status in
            DispatchQueue.main.async {
                self?.updateUI(for: status)
            }
        }
    }
    
    private func updateUI(for status: NotificationAccessStatus) {
        switch status {
        case .authorized, .provisional:
            scrollView.isHidden = false
            registerButton.isHidden = true
            shouldOpenSettings = false
            navigationItem.rightBarButtonItem?.isEnabled = true
            
        case .denied:
            scrollView.isHidden = true
            registerButton.isHidden = false
            registerButton.setTitle("Open Settings", for: .normal)
            shouldOpenSettings = true
            navigationItem.rightBarButtonItem?.isEnabled = false
            
        case .notDetermined:
            scrollView.isHidden = true
            registerButton.isHidden = false
            registerButton.setTitle("Enable Notifications", for: .normal)
            shouldOpenSettings = false
            navigationItem.rightBarButtonItem?.isEnabled = false
            
        default:
            scrollView.isHidden = true
            registerButton.isHidden = false
            shouldOpenSettings = true
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsURL) else {
            return
        }
        UIApplication.shared.open(settingsURL)
    }
    
   
    private func scheduleNotification() {
       
        guard let title = titleTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !title.isEmpty else {
            showAlert(title: "Missing Title", message: "Please enter a notification title.")
            return
        }
        
        guard let body = descriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !body.isEmpty else {
            showAlert(title: "Missing Description", message: "Please enter a notification description.")
            return
        }
        
        let notificationDate = selectedDate ?? datePicker.date
        
        guard notificationDate > Date() else {
            showAlert(title: "Invalid Date", message: "Please select a future date and time.")
            return
        }
        
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let formattedDate = dateFormatter.string(from: notificationDate)
        
     
        let alert = UIAlertController(
            title: "Schedule Notification",
            message: "You will receive a notification on \(formattedDate)",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "Schedule", style: .default) { [weak self] _ in
            self?.performScheduling(title: title, body: body, date: notificationDate)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func performScheduling(title: String, body: String, date: Date) {
        notificationManager.scheduleNotification(
            id: notificationId,
            title: title,
            body: body,
            date: date
        ) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(
                        title: "Scheduling Failed",
                        message: error.localizedDescription
                    )
                } else {
                    self?.showSuccessAndReset()
                }
            }
        }
    }
    
    private func showSuccessAndReset() {
        let alert = UIAlertController(
            title: "Success",
            message: "Your notification has been scheduled successfully!",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.resetForm()
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func resetForm() {
        titleTextView.text = ""
        descriptionTextView.text = ""
        datePicker.date = Date()
        selectedDate = nil
        notificationId = UUID().uuidString
        view.endEditing(true)
    }
    
   
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
