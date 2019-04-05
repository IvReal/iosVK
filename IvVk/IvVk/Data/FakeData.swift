//  FakeData.swift
//  Lesson1.1
//  Created by Iv on 16/03/2019.
//  Copyright © 2019 Iv. All rights reserved.
//

import UIKit

var currentUser: String? = nil

struct Person {
    var name: String
    var foto: UIImage?
    init(_ name: String, _ foto: String) {
        self.name = name
        if !foto.isEmpty {
            self.foto = UIImage(named: foto)
        }
    }
}

class News {
    var author: String
    var date: Date
    var text: String
    var image: UIImage?
    var countLike: Int = 0
    var userLike: Set<String> = []
    var countView: Int = 0
    
    init(author: String, date: Date, text: String, image: String, likes: Int) {
        self.author = author
        self.date = date
        self.text = text
        self.image = UIImage(named: image)
        self.countLike = likes
    }
    
    var isCurrentUserLiked: Bool {
        if let cu = currentUser {
            return userLike.contains(cu)
        }
        return false
    }
    
    // return true if likes increased, false if likes decreased, nil if likes no changed
    func changeLike() -> Bool? {
        var res: Bool? = nil
        if let cu = currentUser {
            if userLike.contains(cu) { // user already liked
                countLike = countLike - 1
                userLike.remove(cu)
                res = false
            } else { // user not liked yet
                countLike = countLike + 1
                userLike.insert(cu)
                res = true
            }
        }
        return res
    }
}

var friends = [
    Person("Алешечкин Вася", "Алешечкин"),
    Person("Мамолькин Илья", "Мамолькин"),
    Person("Харчочкин Заур", "Харчочкин"),
    Person("Васечкин Алеша", "Васечкин"),
    Person("Лебеда Иван Петрович", "Лебеда"),
    Person("Калинина Маша", "Калинина"),
    Person("Иванов Иван", "photo1"),
    Person("Петров Петр", "photo2"),
    Person("Сидоров Сидр", "photo3"),
    Person("Алибабаева Алибаба", "Алибабаева"),
    Person("Кириллов Кирилл", "photo1"),
    Person("Александров Саша", "photo2"),
    Person("Егоров Егор", "photo3"),
    Person("Юрьев Юра", "photo4"),
]

var groups = [
    "Боевые искусства антарктиды",
    "Клуб любителей шампанского Вдова Клико",
    "Программирование на Swift для домохозяек за 5 минут",
    "Европа на автомобиле или тракторе",
    "Обучение французскому во сне"
]

var news = [
    News(author: "Бунин", date: Date.init(timeIntervalSinceNow: 0), text:
        """
        О счастье мы всегда лишь вспоминаем.
        А счастье всюду. Может быть, оно —
        Вот этот сад осенний за сараем
        И чистый воздух, льющийся в окно.
        В бездонном небе легким белым краем
        Встает, сияет облако. Давно
        Слежу за ним… Мы мало видим, знаем,
        А счастье только знающим дано...
        """,
         image: "photo1", likes: 500),
    News(author: "Пушкин", date: Date.init(timeIntervalSinceNow: -20000), text:
        """
        ...Унылая пора! очей очарованье!
        Приятна мне твоя прощальная краса —
        Люблю я пышное природы увяданье,
        В багрец и в золото одетые леса,
        В их сенях ветра шум и свежее дыханье,
        И мглой волнистою покрыты небеса,
        И редкий солнца луч, и первые морозы,
        И отдаленные седой зимы угрозы...
        """,
         image: "photo2", likes: 33),
    News(author: "Лермонтов", date: Date.init(timeIntervalSinceNow: -200000), text:
        """
        Тучки небесные, вечные странники!
        Степью лазурною, цепью жемчужною
        Мчитесь вы, будто как я же, изгнанники
        С милого севера в сторону южную...
        """,
         image: "photo3", likes: 67),
    News(author: "Фет", date: Date.init(timeIntervalSinceNow: -2000000), text:
        """
        Я пришел к тебе с приветом,
        Рассказать, что солнце встало,
        Что оно горячим светом
        По листам затрепетало;
        Рассказать, что лес проснулся,
        Весь проснулся, веткой каждой,
        Каждой птицей встрепенулся
        И весенней полон жаждой;
        Рассказать, что с той же страстью,
        Как вчера, пришел я снова,
        Что душа все так же счастью
        И тебе служить готова;
        Рассказать, что отовсюду
        На меня весельем веет,
        Что не знаю сам, что буду
        Петь — но только песня зреет.
        """,
         image: "photo4", likes: 135)
]