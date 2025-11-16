# Проект: База данных для службы доставки еды

## Цель: сформировать базу данных для приложения по доставке еды из ресторанов

### Ключевые сущности:
 - Заказ (Order)
 - Продукты в заказе (Order_product)
 - Курьер (Courier)
 - Ресторан (Restaurant)
 - Продукты (Product)
 - Отзыв (Review)
 - Адрес доставки (Address)
 - Статус (Status)
 - Клиент (Client)
 - Транспорт курьера (Transport)

### Ключевые связи:
 - Order - Product: Many-to-Many 
 - Order - Review: One-to-Many 
 - Order - Restaurant: Many-to-One
 - Restaurant - Product: Many-to-Many
 - Order - Client: Many-to-One
 - Order - Address: Many-to-One
 - Client - Address: Many-to-Many
 - Order - Status: Many-to-One
 - Order - Courier: Many-to-One
 - Courier - Transport: Many-to-One

### Описание полей: 
#### Order
- order_id - идентификатор заказа
- client_id - идентификатор клиента
- delivery_address_id - идентификатор адреса доставки
- status_id - идентификатор статуса заказа
- courier_id - идентификатор курьера
- restaurant_id - идентификатор ресторана
- create_date - дата создания заказа
- expected_delivery_date - ожидаемая дата доставки
- delivery_date - действительная дата доставки
#### Product
- product_id - идентификатор продукта
- restaurant_id - идентификатор ресторана, в котором данный продукт в наличии
- name - наименование продукта
- price - цена продукта (делаю допущение, что цена во всех ресторанах одинаковая)
- description - описание продукта
#### Review
- review_id - идентификатор отзыва
- order_id - идентификатор заказа, к которому относится отзыв
- grade - оценка товара (5-ти бальная)
- text - текст отзыва
#### Restaurant 
- restaurant_id - идентификатор ресторана
- name - наименование ресторана
- address - адрес ресторана
- phone_number - телефон для связи с рестораном
- working_hours - рабочее время ресторана
#### Order_product
- order_id - идентификатор заказа
- product_id - идентификатор продукта
- count_of_products - количество продуктов в заказе
#### Client
- client_id - идентификатор клиента
- firstname - имя клиента
- lastname - фамилия клиента
- email - электронная почта клиента
- phone_number - номер телефона для связи
#### Address
- address_id - идентификатор адреса клиента
- address_name - адрес клиента
- client_id - идентификатор клиента
#### Status
- status_id - идентификатор статуса заказа
- name - наименование статуса
#### Courier
- courier_id  - идентификатор курьера
- firstname - имя курьера
- lastname - фамилия курьера
- email - электронный адрес
- phone_number - телефон для связи
- avarage_grage - средняя оценка
- transport_id - идентификатор транспорта, которым пользуется курьер
#### Status
- transport_id - идентификатор транспорта
- name - наименование транспорта
### Примеры бизнес-задач:
1. Клиент установил в приложении список адресов доставки.
2. Клиент зашел в приложение, выбрал ресторан, выбрал блюда/продукты, оформил заказ.
3. Алгоритм приложения определил заказ на оптимального курьера с учетом транспорта.
4. Статус заказа менялся: оформлен -> в сборке -> в доставке -> доставлен.
5. Клиент получил заказ и оставил оценку за заказ.

![delivery_db.png](diagrams%2Fdelivery_db.png)