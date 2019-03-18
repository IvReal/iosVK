//  FakeData.swift
//  Lesson1.1
//  Created by Iv on 16/03/2019.
//  Copyright © 2019 Iv. All rights reserved.
//

import UIKit

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

var friends = [
    Person("Алешечкин Вася", "Алешечкин"),
    Person("Мамолькин Илья", "Мамолькин"),
    Person("Харчочкин Заур", "Харчочкин"),
    Person("Васечкин Алеша", "Васечкин"),
    Person("Лебеда Иван Петрович", "Лебеда"),
    Person("Калинина Маша", "Калинина"),
    Person("Иванов Иван", "photo1"),
    Person("Петров Петр", "photo1"),
    Person("Сидоров Сидр", "photo1"),
    Person("Алибабаева Алибаба", "Алибабаева"),
    Person("Кириллов Кирилл", "photo1"),
    Person("Александров Саша", "photo1"),
    Person("Егоров Егор", "photo1"),
    Person("Юрьев Юра", "photo1"),
]

var groups = [
    "Клуб любителей шампанского",
    "Программирование на Swift для домохозяек",
    "Европа на автомобиле",
    "Боевые искусства антарктиды",
    "Обучение французскому во сне"
]
