//
//  EditPersonViewController.swift
//  Inspiring
//
//  Created by Benjamin Mecanovic on 21/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import UIKit

class CustomizePersonViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var dateOfDeathTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var quotesLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var quotesTableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    // MARK: - Properties
    private var viewModel: CustomizePersonViewModel!
    private let cellIdentifier = "QuoteTableViewCell"
    private var activeTextField : UITextField? = nil

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CustomizePersonViewModel(delegate: self)
        setupUI()
        prepeareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        quotesTableView.reloadData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.resetData()
    }
    
    final func prepeareUI() {
        quoteTextView.delegate = self
        quotesTableView.delegate = self
        quotesTableView.dataSource = self
        quotesTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    final func setupUI() {
        let dismissInputUITapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissInputUI))
        view.addGestureRecognizer(dismissInputUITapGesture)
        
        let openGalleryTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGalleryOpening))
        pictureImageView.addGestureRecognizer(openGalleryTapGesture)
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveButtonTapped))
        navItem.rightBarButtonItem = saveButton
        
        pictureImageView.layer.masksToBounds = true
        pictureImageView.layer.cornerRadius = 5
        descriptionLabel.layer.masksToBounds = true
        descriptionLabel.layer.cornerRadius = 5
        descriptionTextView.layer.masksToBounds = true
        descriptionTextView.layer.cornerRadius = 5
        quotesLabel.layer.masksToBounds = true
        quotesLabel.layer.cornerRadius = 5
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 5
        quoteTextView.layer.masksToBounds = true
        quoteTextView.layer.cornerRadius = 5
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: attributes)
        dateOfBirthTextField.attributedPlaceholder = NSAttributedString(string: "Date of Birth", attributes: attributes)
        dateOfDeathTextField.attributedPlaceholder = NSAttributedString(string: "Date of Death", attributes: attributes)
    }
    
    // MARK: - Actions
    @IBAction private func addButtonPressed(_ sender: UIButton) {
        viewModel.add(quoteMessage: quoteTextView.text)
        quotesTableView.reloadData()
    }
    
    @IBAction private func dateOfBirthTapped(_ sender: UITextField) {
        let datePicker = CustomDatePicker()
        datePicker.datePickerMode = .date
        datePicker.type = .dob
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        dateOfBirthTextField.inputView = datePicker
    }
    
    @IBAction private func dateOfDeathTapped(_ sender: UITextField) {
        let datePicker = CustomDatePicker()
        datePicker.datePickerMode = .date
        datePicker.type = .dod
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        dateOfDeathTextField.inputView = datePicker
    }
    
    // MARK: - Methods
    
    @objc private func handleSaveButtonTapped() {
        viewModel.customizePerson(name: nameTextField.text ?? "",
                                  dateOfBirth: dateOfBirthTextField.text ?? "",
                                  dateOfDeath: dateOfDeathTextField.text ?? "",
                                  description: descriptionTextView.text)
        tabBarController?.selectedIndex = 0
    }
    
    @objc private func handleDatePicker(sender: CustomDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if sender.type == .dob {
            dateOfBirthTextField.text = dateFormatter.string(from: sender.date)
        } else {
            dateOfDeathTextField.text = dateFormatter.string(from: sender.date)
        }
        
    }
    
    @objc private func handleDismissInputUI() {
        view.endEditing(true)
    }
    
    @objc private func handleGalleryOpening() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image"]
        present(imagePicker, animated: true, completion: nil)
    }
}

extension CustomizePersonViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageUrl = info[.imageURL] as? URL {
            if let imageData = try? Data(contentsOf: imageUrl) {
                pictureImageView.image = UIImage(data: imageData)
            }
            viewModel.add(imageUrl: imageUrl.absoluteString)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CustomizePersonViewController: CustomizePersonViewModelDelegate {
    func didStateChange(person: Person?) {
        if let person = person {
            if let url = URL(string: person.imageUrl ?? ""), let imageData = try? Data(contentsOf: url) {
                pictureImageView.image = UIImage(data: imageData)
            }
            nameTextField.text = person.name
            dateOfBirthTextField.text = person.dob
            dateOfDeathTextField.text = person.dod
            descriptionTextView.text = person.personDescription
            quoteTextView.text = ""
            navItem.title = "Edit"
        } else {
            pictureImageView.image = nil
            nameTextField.text = ""
            dateOfBirthTextField.text = ""
            dateOfDeathTextField.text = ""
            descriptionTextView.text = ""
            quoteTextView.text = ""
            navItem.title = "Create"
        }
    }
}

extension CustomizePersonViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightOfRow
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightOfRow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! QuoteTableViewCell
        cell.config(quote: viewModel.getQuoteMessage(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         
        let removeAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, _) in
            self?.viewModel.removeQuote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        removeAction.image = UIImage(systemName: "trash")
        removeAction.backgroundColor = .systemRed
         
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
}

extension CustomizePersonViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let welf = self else { return }
            let frame = welf.view.frame
            welf.view.frame = CGRect(x: frame.origin.x, y: frame.origin.y - 100, width: frame.width, height: frame.height)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let welf = self else { return }
            let frame = welf.view.frame
            welf.view.frame = CGRect(x: frame.origin.x, y: frame.origin.y + 100, width: frame.width, height: frame.height)
        }
    }
    
}
