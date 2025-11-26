# Проект: База данных для службы доставки еды

## Цель: сформировать базу данных для приложения по доставке товаров из магазинов

![delivery_db.png](diagrams%2Fdelivery_db.png)

### Ключевые сущности:
 - Заказ (Order)
 - Продукт (Product)
 - Отзыв (Review)
 - Магазин (Store)
 - Клиент (Client)
 - Адрес (Address)
 - Статус (Status)
 - Курьер (Courier)
 - Транспорт (Transport)
 - Рабочее время (OperatingHours)
 - День недели (DayOfWeek)
 - Категория продукта (ProductCategory)
 - Город (City)
 - Транзакции (Transaction)

### Связующие таблицы
- Продукты в заказе (OrderProduct)
- Продукты в магазине (StoreProduct)
- Адрес клиента (ClientAddress)

### Ключевые отношения:
One-to-One
- OperatingHours - DayOfWeek

One-to-Many
- Order - Review: One-to-Many
- Order - Transaction
- Store - Order
- Client - Order
- Address - Order
- Status - Order
- Courier - Order
- Store - Address
- Store - OperatingHours
- City - Address
- ProductCategory - Product
- Transport - Courier

Many-to-Many
- Order - Product: OrderProduct
- Store - Product: StoreProduct
- Client - Address: ClientAddress
- 
### Описание полей: 
#### Order
- id - идентификатор заказа
- client_id - идентификатор клиента
- delivery_address_id - идентификатор адреса доставки
- status_id - идентификатор статуса заказа
- courier_id - идентификатор курьера
- store_id - идентификатор ресторана
- transaction_id - идентификатор транзакции
- create_date - дата создания заказа
- expected_delivery_date - ожидаемая дата доставки
- delivery_date - действительная дата доставки
#### Product
- id - идентификатор продукта
- category_id - идентификатор категории продукта
- name - наименование продукта
- description - описание продукта
#### Review
- id - идентификатор отзыва
- order_id - идентификатор заказа, к которому относится отзыв
- grade - оценка товара (5-ти бальная)
- text - текст отзыва
#### Store 
- id - идентификатор ресторана
- address_id - адрес ресторана
- name - наименование ресторана
- phone - телефон для связи с рестораном
- grade - оценка ресторана
#### Client
- id - идентификатор клиента
- firstname - имя клиента
- lastname - фамилия клиента
- email - электронная почта клиента
- phone - номер телефона для связи
#### Address
- id - идентификатор адреса клиента
- city_id - идентификатор города
- street - улица
- house - номер дома
- entrance - номер подъезда
- apartment - номер квартиры
#### Status
- id - идентификатор статуса заказа
- name - наименование статуса
#### Courier
- id - идентификатор курьера
- transport_id - идентификатор транспорта, которым пользуется курьер
- firstname - имя курьера
- lastname - фамилия курьера
- email - электронный адрес
- phone - телефон для связи
- grade - средняя оценка
#### Transport
- id - идентификатор транспорта
- name - наименование транспорта
- diameter - наименование транспорта
#### OperatingHours
- id - идентификатор времени работы
- store_id - идентификатор магазина
- day_of_week_id - идентификатор дня недели
- open_time - время открытия
- open_time - время закрытия
- is_сlosed - закрыт ли
#### DayOfWeek
- id - идентификатор дня недели
- name - наименование дня недели
#### ProductCategory
- id - идентификатор категории
- name - наименование категории
#### City
- id - идентификатор города
- name - наименование города
#### Transaction
- id - идентификатор транзакции
- sum - сумма транзакции
#### OrderProduct
- order_id - идентификатор заказа
- product_id - идентификатор продукта
- amount - количество продуктов в заказе
#### StoreProduct
- store_id - идентификатор магазина
- product_id - идентификатор продукта
- price - цена товара в магазине
- amount - количество товаров в магазине
- measurement - единица измерения товара
#### ClientAddress
- client_id - идентификатор клиента
- address_id - идентификатор адреса
### Примеры бизнес-задач:
1. Клиент установил в приложении список адресов доставки.
2. Клиент зашел в приложение, выбрал ресторан, выбрал блюда/продукты, оформил заказ.
3. Алгоритм приложения определил заказ на оптимального курьера с учетом транспорта.
4. Статус заказа менялся: оформлен -> в сборке -> в доставке -> доставлен.
5. Клиент получил заказ и оставил оценку за заказ.

Улучшения:
- Добавить оценку ресторана +
- Продумать таблицы связанные с оплатой заказа +
- Исправить одинаковые цены во всех ресторанах +
- Добавить в схему еще и магазины, доставка не только из ресторанов +
- Добавить для транспорта диапазон действия +
- Добавить категорию товара +
- Добавить город в адрес +
- Изменить тип адреса у ресторана +
- Добавить таблицу рабочих часов магазина +

1. Проводим анализ возможных запросов\отчетов\поиска данных.
- Найти самый дорогой заказ за месяц и его оформителя. +
- Определить самого результативного курьера +
- Посчитать количество заказов в ресторане за месяц +
- Пользователь ищет в приложении конкретный ресторан +
- Найти пользователя/курьера по имени и фамилии +
- Найти пользователя/ресторан/магазин по номеру телефона +
- Найти продукты магазина +
- Пользователь заходит в приложение по номеру телефона +
- Курьер заходит в приложение по номеру телефона +
- Найти адрес доставки +
- Найти товары по имени +
- Найти все товары в категории +

2. Предполагаем возможную кардинальность поля.
3. Создаем дополнительные индексы - простые или композитные.

CREATE INDEX idx_client_phone ON Client (phone); - быстрый поиск клиента при входе в приложение по номеру телефона
CREATE INDEX idx_courier_phone ON Courier (phone); - быстрый поиск курьера при входе в приложение по номеру телефона
CREATE INDEX idx_courier_fullname ON Courier (lastname, firstname); - быстрый поиск курьера по фамилии и имени в бухгалтерии
CREATE INDEX idx_address_city_street ON Address (city_id, street); - быстрый поиск адресов по городу и улице
CREATE INDEX idx_product_name ON Product (name); - быстрый поиск товара в приложении по имени
CREATE INDEX idx_product_category ON Product (category_id); - быстрый поиск товаров в приложении по категории
CREATE INDEX idx_store ON StoreProduct (store_id); - быстрое определение ассортимента магазина
CREATE INDEX idx_store_name ON Store (name); - быстрый поиск магазина для определения ассортимента
CREATE INDEX idx_store_order ON Order (store_id); - посмотреть количество заказов в магазине за месяц
CREATE INDEX idx_courier_order ON Order (courier_id); - посмотреть количество выполненных заказов курьера за месяц
CREATE INDEX idx_client_order ON Order (client_id); - посмотреть количество заказов пользователя за месяц

4. На каждый индекс пишем краткое описание зачем он нужен (почему по этому полю\полям).
5. Думаем какие логические ограничения в БД нужно добавить - например какие поля должны быть уникальны, в какие нужно добавить условия, чтобы не нарушить бизнес логику. Пример - нельзя провести операцию по переводу средств на отрицательную сумму.

ALTER TABLE Transaction ADD CONSTRAINT sum_constraint CHECK (sum >= 0); - сумма транзакции не может быть меньше 0
ALTER TABLE Courier ADD CONSTRAINT grade_constraint CHECK (grade BETWEEN 0 AND 5); - оценка курьера может быть в диапазоне от 0 до 5
ALTER TABLE Store ADD CONSTRAINT grade_constraint CHECK (grade BETWEEN 0 AND 5); - оценка магазина может быть в диапазоне от 0 до 5
ALTER TABLE Review ADD CONSTRAINT grade_constraint CHECK (grade BETWEEN 0 AND 5); - оценка может быть в диапазоне от 0 до 5
ALTER TABLE StoreProduct ADD CONSTRAINT PK_StoreProduct PRIMARY KEY (store_id, product_id); - значение пары столбцов store_id и product_id должны быть уникальными
ALTER TABLE OrderProduct ADD CONSTRAINT amount_constraint CHECK (amount >= 0); - количество товаров не меньше 0
ALTER TABLE StoreProduct ADD CONSTRAINT price_constraint CHECK (price >= 0); - цена товара не меньше 0
ALTER TABLE Transport ADD CONSTRAINT name_constraint UNIQUE (name); - не должен повторяться тип транспорта
ALTER TABLE Courier ADD CONSTRAINT unique_phone_constraint UNIQUE (phone); - не должен повторяться номер телефона курьера
ALTER TABLE Client ADD CONSTRAINT unique_phone_constraint UNIQUE (phone); - не должен повторяться номер телефона клиента
ALTER TABLE Store ADD CONSTRAINT unique_phone_constraint UNIQUE (phone); - не должен повторяться номер телефона магазина
ALTER TABLE Courier ADD CONSTRAINT unique_email_constraint UNIQUE (email); - не должен повторяться email курьера
ALTER TABLE Client ADD CONSTRAINT unique_email_constraint UNIQUE (email); - не должен повторяться email клиента
ALTER TABLE DayOfWeek ADD CONSTRAINT name_constraint UNIQUE (name); - не должен повторяться день недели
ALTER TABLE City ADD CONSTRAINT name_constraint UNIQUE (name); - не должен повторяться город
ALTER TABLE Status ADD CONSTRAINT name_constraint UNIQUE (name); - не должен повторяться статус заказа
ALTER TABLE ProductCategory ADD CONSTRAINT name_constraint UNIQUE (name); - не должна повторяться категория продукта
ALTER TABLE Order ADD CONSTRAINT time_constraint CHECK (expected_delivery_date > create_date AND delivery_date > create_date); - ожидаемая дата доставки должна быть больше даты создания заказа

6. Создаем ограничения по выбранным полям.