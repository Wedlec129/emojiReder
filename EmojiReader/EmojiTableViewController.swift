//
//  EmojiTableViewController.swift
//  EmojiReader
//
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    //гаши обекты класса из emojiModel
    var objects = [
        Emoji(emoji: "🥰", name: "Love", description: "Let's love each other", isFavourite: false),
        Emoji(emoji: "⚽️", name: "Football", description: "Let's play football together", isFavourite: false),
        Emoji(emoji: "🐱", name: "Cat", description: "Cat is the cutest animal", isFavourite: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        self.title = "Emoji Reader" //заголовок
        self.navigationItem.leftBarButtonItem = self.editButtonItem //кнопка изменить
        
    }
    
    // MARK: - Table view data source
    
    //колличество секцияй
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //количество элементов в одной секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! EmojiTableViewCell
        
       
        cell.set(object: objects[indexPath.row]) //ф-я ячейки установка всех параметров
        
        return cell
    }
    
    //определяем редактирование на удаление
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    
    
    //определяем если событие удалить
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //удаляем в массиве и в отображении)
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade) //tableView.reloadData()
        }
        
    }
    
    
    //можем ли мы двигать (менять позицию элементов)
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true //да
    }
    //как осуществляется перемешение
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedEmoji = objects.remove(at: sourceIndexPath.row)
        objects.insert(movedEmoji, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    //возврашаем обекты лля свайпа слева а если справа(trailingSwipeActionsConfigurationForRowAt)
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //типо 2 ф-я
        let done = doneAction(at: indexPath)
        let favourite = favouriteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [done, favourite])
    }
    
    //возвращаемые знчения события
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") { (action, view, completion) in
            
            self.objects.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completion(true)//завершаем действие кнопки
        }
        
        action.backgroundColor = .systemGreen //цвет заднего фона
        action.image = UIImage(systemName: "checkmark.circle") //картинка
        
        return action
    }
    
    func favouriteAction(at indexPath: IndexPath) -> UIContextualAction {
        var object = objects[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Favourite") { (action, view, completion) in
            object.isFavourite = !object.isFavourite
            self.objects[indexPath.row] = object
            completion(true)
        }
        action.backgroundColor = object.isFavourite ? .systemPurple : .systemGray
        action.image = UIImage(systemName: "heart")
        return action
    }
    
    
    
    
    
    
    //обрабодка ф-я перехода с другого контроллера на этот
    //когда я возвращаюсь с другого экрана обрвтно в главный
    @IBAction func unwindSegueEmojiTaibleVC(segue:UIStoryboardSegue){
        
        
        //если переход был по индификатору saveSegue то доюавляем новый обект
        guard segue.identifier == "saveSegue" else {return}
        let sourceVC = segue.source as! newEmojiTableViewController //получаем vc того экрана что бы брать от туда его значения
        
        let emoji = sourceVC.emoji //получаем переменную которую нужно добавить
    
        
        //если мы нажимали на сушествующуюю (редактирование)
        if let selectIndexPath=tableView.indexPathForSelectedRow{
            objects[selectIndexPath.row]=emoji
            tableView.reloadRows(at: [selectIndexPath], with: .fade)//
        }
        
        // если создаём новый
        else{
            
            //узнаём куда поставить
            let newIndexPath = IndexPath(row: objects.count, section: 0)
            objects.append(emoji)   //ставим
            tableView.insertRows(at: [newIndexPath], with: .fade)//
            //записываем в таблицу
        }
        
    }
    
    
    
    
    
    //типо обработка события переход на другой экран с передачей наших значений
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editEmoji" else { return }
        let indexPath = tableView.indexPathForSelectedRow!
        let emoji = objects[indexPath.row]
        let navigaionVC = segue.destination as! UINavigationController
        let newEmojiVC = navigaionVC.topViewController as! newEmojiTableViewController
        newEmojiVC.emoji = emoji //то эмоджи = нажатому 
        newEmojiVC.title = "Edit"
    }
    
    
    
}
