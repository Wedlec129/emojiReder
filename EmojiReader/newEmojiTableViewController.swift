//
//  newEmojiTableViewController.swift
//  EmojiReader
//
//  Created by Борух Соколов on 15.04.2023.
//  Copyright © 2023 Алексей Пархоменко. All rights reserved.
//

import UIKit

class newEmojiTableViewController: UITableViewController {
    
    //ссылки на текстовые поля
    @IBOutlet weak var emojiTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextFiled: UITextField!
    
    //кнопка сохранения
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //пустой обект новой эмоции
    var emoji=Emoji(emoji: "", name: "", description: "", isFavourite: false)
    //мы при сохранение его заполним и потом получим доступ к нему при переходе
    
    //ф-я для провекрки можем ли мы использовать кнопку сохранить
    private func updateSaveButtonState(){
        //получаем значение кажого поля
        let emojiText = emojiTextField.text ?? ""
        let nameText = nameTextField.text ?? ""
        let descriptionText = descriptionTextFiled.text ?? ""
        
        //можем ли использовать
        //если поля не пустые
        saveButton.isEnabled = !emojiText.isEmpty && !nameText.isEmpty && !descriptionText.isEmpty

    }
    
    //как загрузился экран проверяем можем ли мы сохранить
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonState()
        
        
        updateUI()
    }
    
    //как только текст наших полей меняется проверяем можем ли мы их сохранить
    @IBAction func textChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    

    
    // обработка события переход
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //если мы осущуествили переход saveSegue изменяем нашу emoji
        guard segue.identifier == "saveSegue" else { return }
        
        let emojiText = emojiTextField.text ?? ""
        let nameText = nameTextField.text ?? ""
        let descriptionText = descriptionTextFiled.text ?? ""
        
        self.emoji=Emoji(emoji: emojiText, name: nameText, description: descriptionText, isFavourite: false)
        
        
    }
    
    
    
    private func updateUI() {
        emojiTextField.text = emoji.emoji
        nameTextField.text = emoji.name
        descriptionTextFiled.text = emoji.description
    }
    
    
}
