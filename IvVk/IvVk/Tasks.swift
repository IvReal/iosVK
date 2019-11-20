//
//  Tasks.swift
//  IvVk
//
//  Created by Iv on 07.11.2019.
//  Copyright © 2019 Iv. All rights reserved.
//

import Foundation

// Архитектуры и шаблоны программирования на Swift

/* LESSON 3
 2. Найдите все места в проекте, где используются экземпляры UIColor и UIFont. Примените flyweight, чтобы избежать лишней инициализации объектов.
 3. Найдите в проекте код, отвечающий за получение данных из сети: получение списка новостей, друзей, фотографий и т. д. В шаблоне по ссылке выше за это отвечает AlamofireService, в методах которого данные асинхронно передаются с помощью паттерна «делегат». Отрефакторите код так, чтобы данные асинхронно возвращались в замыкание, которое передается параметром (аналогично тому, как мы сделали на уроке). При этом не меняйте существующие классы — воспользуйтесь паттерном adapter.
 4. Найдите в проекте код, который отвечает за UI — отображение пришедших с сервера данных. Это все ячейки table view / collection view, отображение данных во вью-контроллере, сторибордах и т. д. Найдите код, который преобразует сырые данные из моделей в информацию для отображения. Воспользуйтесь паттерном simple factory и создавайте вью-модели, по которым будет отрисовываться интерфейс.
 */