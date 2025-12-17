-- Создать табличное пространство
create tablespace delivery_ts LOCATION '/var/lib/postgresql/delivery_ts';

-- Создать базу данных
create database delivery with tablespace delivery_ts;

-- Создать роли
create role "ProducersDeveloper" login;
create role "DeliveryDeveloper" login;
create role "ConsumersDeveloper" login;
create role "BankingDeveloper" login;

create role "ProducersClient" login;
create role "DeliveryClient" login;
create role "ConsumersClient" login;
create role "BankingClient" login;

-- Создать схемы
create schema if not exists producers authorization "ProducersDeveloper";
create schema if not exists delivery authorization "DeliveryDeveloper";
create schema if not exists consumers authorization "ConsumersDeveloper";
create schema if not exists banking authorization "BankingDeveloper";

-- Создать таблицы
create table if not exists consumers.City
(
    id   bigint primary key,
    name character(100) unique
);

create table if not exists delivery.Transport
(
    id       bigint primary key,
    name     character(100) unique,
    diameter smallint
);

create table if not exists producers.DayOfWeek
(
    id   bigint primary key,
    name character(30) unique
);

create table if not exists producers.ProductCategory
(
    id   bigint primary key,
    name character(100) unique
);

create table if not exists banking.Transaction
(
    id  bigint primary key,
    sum money check (sum >= 0::money)
);

create table if not exists delivery.Status
(
    id   bigint primary key,
    name character(30) unique
);

create table if not exists consumers.Client
(
    id        bigint primary key,
    firstname character(100),
    lastname  character(100),
    email     character(100) unique,
    phone     character(30) unique
);
CREATE INDEX if not exists idx_client_phone ON consumers.Client (phone);

create table if not exists consumers.Address
(
    id        bigint primary key,
    city_id   bigint references consumers.City (id),
    street    character(200),
    house     character(200),
    entrance  character(200),
    apartment character(200)
);
CREATE INDEX if not exists idx_address_city_street ON consumers.Address (city_id, street);

create table if not exists consumers.ClientAddress
(
    client_id  bigint references consumers.City (id),
    address_id bigint references consumers.Address (id)
);

create table if not exists delivery.courier
(
    id           bigint primary key,
    transport_id bigint references delivery.Transport (id),
    firstname    character(100),
    lastname     character(100),
    email        character(100) unique,
    phone        character(30) unique,
    grade        decimal check (grade BETWEEN 0 AND 5)
);
CREATE INDEX if not exists idx_courier_phone ON delivery.courier (phone);
CREATE INDEX if not exists idx_courier_fullname ON delivery.courier (lastname, firstname);

create table if not exists producers.Product
(
    id          bigint primary key,
    category_id bigint references producers.ProductCategory (id),
    name        character(100),
    description text
);
CREATE INDEX if not exists idx_product_name ON producers.Product (name);
CREATE INDEX if not exists idx_product_category ON producers.Product (category_id);

create table if not exists producers.Store
(
    id         bigint primary key,
    address_id bigint,
    name       character(100),
    phone      character(30) unique,
    grade      decimal CHECK (grade BETWEEN 0 AND 5)
);
CREATE INDEX if not exists idx_store_name ON producers.Store (name);

create table if not exists producers.StoreProduct
(
    store_id    bigint references producers.Store (id),
    product_id  bigint references producers.Product (id),
    price       decimal CHECK (price >= 0),
    amount      bigint,
    measurement character(30),
    primary key (store_id, product_id)
);
CREATE INDEX if not exists idx_store ON producers.StoreProduct (store_id);

create table if not exists producers.OperatingHours
(
    id             bigint primary key,
    store_id       bigint references producers.Store (id),
    day_of_week_id bigint references producers.DayOfWeek (id),
    open_time      time,
    close_time     time,
    is_сlosed      boolean
);

create table if not exists delivery."Order"
(
    id                     bigint primary key,
    client_id              bigint references consumers.Client (id),
    delivery_address_id    bigint references consumers.Address (id),
    status_id              bigint references delivery.Status (id),
    courier_id             bigint references delivery.courier (id),
    store_id               bigint references producers.Store (id),
    transaction_id         bigint references banking.Transaction (id),
    create_date            timestamp,
    expected_delivery_date timestamp,
    delivery_date          timestamp,
    CONSTRAINT time_constraint CHECK (expected_delivery_date > create_date AND delivery_date > create_date)
);
CREATE INDEX if not exists idx_store_order ON delivery."Order" (store_id);
CREATE INDEX if not exists idx_courier_order ON delivery."Order" (courier_id);
CREATE INDEX if not exists idx_client_order ON delivery."Order" (client_id);

create table if not exists delivery.Review
(
    id       bigint primary key,
    order_id bigint references delivery."Order" (id),
    grade    bigint CHECK (grade BETWEEN 0 AND 5),
    text     text
);

create table if not exists delivery.OrderProduct
(
    order_id   bigint references delivery."Order" (id),
    product_id bigint references producers.Product (id),
    amount     bigint CHECK (amount >= 0)
);

-- Назначить права ролям
GRANT USAGE ON SCHEMA
    producers,
    delivery,
    banking,
    consumers
TO "ProducersClient",
    "DeliveryClient",
    "BankingClient",
    "ConsumersDeveloper",
    "ProducersDeveloper",
    "DeliveryDeveloper",
    "BankingDeveloper",
    "ConsumersDeveloper";

grant all privileges on all tables in schema producers to "ProducersDeveloper";
grant all privileges on all tables in schema delivery to "DeliveryDeveloper";
grant all privileges on all tables in schema banking to "BankingDeveloper";
grant all privileges on all tables in schema consumers to "ConsumersDeveloper";

grant select, update, insert, delete on all tables in schema producers to "ProducersClient";
grant select, update, insert, delete on all tables in schema delivery to "DeliveryClient";
grant select, update, insert, delete on all tables in schema banking to "BankingClient";
grant select, update, insert, delete on all tables in schema consumers to "ConsumersClient";

grant select on all tables in schema
    delivery
to
    "ProducersDeveloper",
    "ProducersClient",
    "BankingDeveloper",
    "BankingClient",
    "ConsumersDeveloper",
    "ConsumersClient";

grant select on all tables in schema
    producers,
    banking,
    consumers
to
    "DeliveryDeveloper",
    "DeliveryClient";
