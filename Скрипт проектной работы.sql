-- Скрипт для создания таблиц.

SET search_path TO public;

-- 1. Клиенты
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Сотрудники
CREATE TABLE Employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    role VARCHAR(50)
);

-- 3. Поставщики
CREATE TABLE Suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100)
);

-- 4. Категории
CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- 5. Товары
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL,
    stock INT DEFAULT 0,
    category_id INT REFERENCES Categories(category_id),
    supplier_id INT REFERENCES Suppliers(supplier_id)
);

-- 6. Заказы
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    employee_id INT REFERENCES Employees(employee_id),
    payment_method_id INT,
    shipping_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'pending'
);

-- 7. Товары в заказе
CREATE TABLE Order_Items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT DEFAULT 1,
    price NUMERIC(10,2)
);

-- 8. Корзина
CREATE TABLE Cart (
    cart_id SERIAL PRIMARY KEY,
    customer_id INT UNIQUE REFERENCES Customers(customer_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Товары в корзине
CREATE TABLE Cart_Items (
    cart_item_id SERIAL PRIMARY KEY,
    cart_id INT REFERENCES Cart(cart_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT DEFAULT 1
);

-- 10. Отзывы
CREATE TABLE Product_Reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES Products(product_id),
    customer_id INT REFERENCES Customers(customer_id),
    rating INT CHECK(rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. Методы оплаты
CREATE TABLE Payment_Methods (
    payment_method_id SERIAL PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL
);

-- 12. Доставка
CREATE TABLE Shipping (
    shipping_id SERIAL PRIMARY KEY,
    address TEXT NOT NULL,
    city VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50)
);

-- 13. Скидки
CREATE TABLE Discounts (
    discount_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    description TEXT,
    discount_percent NUMERIC(5,2) CHECK(discount_percent >= 0 AND discount_percent <= 100),
    start_date DATE,
    end_date DATE
);

-- 14. Списки желаемого
CREATE TABLE Wishlist (
    wishlist_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 15. Товары в списке желаемого
CREATE TABLE Wishlist_Items (
    wishlist_item_id SERIAL PRIMARY KEY,
    wishlist_id INT REFERENCES Wishlist(wishlist_id),
    product_id INT REFERENCES Products(product_id)
);

-- 16. Связь товаров со скидками (многие ко многим)
CREATE TABLE Product_Discounts (
    product_discount_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES Products(product_id),
    discount_id INT REFERENCES Discounts(discount_id)
);


-- ВСТАВКА ДАННЫХ

-- 1. Клиенты

INSERT INTO Customers(first_name, last_name, email, phone)
VALUES
('Иван', 'Иванов', 'ivan.ivanov@mail.ru', '+79991112233'),
('Мария', 'Петрова', 'maria.petrova@mail.ru', '+79992223344'),
('Сергей', 'Сидоров', 'sergey.sidorov@mail.ru', '+79993334455'),
('Ольга', 'Кузнецова', 'olga.k@mail.ru', '+79994445566'),
('Алексей', 'Смирнов', 'aleksey.s@mail.ru', '+79995556677'),
('Наталья', 'Попова', 'natalia.p@mail.ru', '+79996667788'),
('Дмитрий', 'Лебедев', 'dmitry.l@mail.ru', '+79997778899');


-- 2. Сотрудники

INSERT INTO Employees(first_name, last_name, email, role)
VALUES
('Алексей', 'Кузнецов', 'aleksey.k@mail.ru', 'Менеджер'),
('Ольга', 'Смирнова', 'olga.s@mail.ru', 'Менеджер'),
('Ирина', 'Федорова', 'irina.f@mail.ru', 'Менеджер'),
('Сергей', 'Петров', 'sergey.p@mail.ru', 'Менеджер'),
('Марина', 'Васильева', 'marina.v@mail.ru', 'Менеджер'),
('Дмитрий', 'Орлов', 'dmitry.o@mail.ru', 'Менеджер'),
('Елена', 'Крылова', 'elena.k@mail.ru', 'Менеджер');


-- 3. Поставщики

INSERT INTO Suppliers(name, contact_email)
VALUES
('ООО "Техника"', 'tech@suppliers.ru'),
('ЗАО "Электроника"', 'electronics@suppliers.ru'),
('ООО "Комплект"', 'komplekt@suppliers.ru'),
('ЗАО "ГаджетСервис"', 'gadget@suppliers.ru'),
('ООО "Ноутбуки"', 'notebooks@suppliers.ru'),
('ЗАО "Телевизоры"', 'tv@suppliers.ru'),
('ООО "Аксессуары"', 'accessories@suppliers.ru');

-- ===============================
-- 4. Категории (7)
-- ===============================
INSERT INTO Categories(name)
VALUES
('Смартфоны'),
('Ноутбуки'),
('Планшеты'),
('Фотоаппараты'),
('Телевизоры'),
('Наушники'),
('Мыши');

-- ===============================
-- 5. Товары (~30)
-- ===============================
INSERT INTO Products(name, description, price, stock, category_id, supplier_id)
VALUES
('iPhone 14', 'Смартфон Apple', 90000, 10, 1, 1),
('Samsung Galaxy S23', 'Смартфон Samsung', 80000, 15, 1, 2),
('Xiaomi Redmi Note 12', 'Смартфон Xiaomi', 30000, 20, 1, 2),
('Huawei P50', 'Смартфон Huawei', 40000, 12, 1, 2),
('Sony Xperia 10', 'Смартфон Sony', 35000, 10, 1, 2),
('Realme 9', 'Смартфон Realme', 25000, 18, 1, 2),
('MacBook Pro 16', 'Ноутбук Apple', 200000, 5, 2, 1),
('MacBook Air', 'Ноутбук Apple', 150000, 8, 2, 1),
('Lenovo ThinkPad', 'Ноутбук Lenovo', 120000, 8, 2, 2),
('Lenovo Yoga', 'Ноутбук Lenovo', 110000, 10, 2, 2),
('Asus ZenBook', 'Ноутбук Asus', 130000, 7, 2, 2),
('Dell XPS 15', 'Ноутбук Dell', 140000, 6, 2, 2),
('iPad Pro', 'Планшет Apple', 80000, 10, 3, 1),
('Samsung Galaxy Tab S8', 'Планшет Samsung', 60000, 12, 3, 2),
('Xiaomi Pad 5', 'Планшет Xiaomi', 35000, 15, 3, 2),
('Canon EOS R6', 'Фотоаппарат Canon', 250000, 4, 4, 2),
('Nikon Z6', 'Фотоаппарат Nikon', 220000, 5, 4, 2),
('GoPro Hero 10', 'Экшн-камера GoPro', 50000, 8, 4, 2),
('Sony Alpha 7', 'Фотоаппарат Sony', 230000, 3, 4, 2),
('Samsung Smart TV 55', 'Телевизор Samsung', 70000, 7, 5, 2),
('LG OLED TV 65', 'Телевизор LG', 150000, 3, 5, 2),
('Sony Bravia 50', 'Телевизор Sony', 90000, 5, 5, 2),
('Xiaomi Mi TV 55', 'Телевизор Xiaomi', 40000, 10, 5, 2),
('Samsung Galaxy Buds', 'Наушники Samsung', 10000, 20, 6, 2),
('Apple AirPods', 'Наушники Apple', 15000, 15, 6, 1),
('Xiaomi Mi AirDots', 'Наушники Xiaomi', 5000, 25, 6, 2),
('Logitech MX Master', 'Мышь Logitech', 8000, 12, 7, 2),
('Razer DeathAdder', 'Мышь Razer', 6000, 10, 7, 2),
('HP Pavilion 15', 'Ноутбук HP', 90000, 5, 2, 2),
('Huawei MateBook D', 'Ноутбук Huawei', 85000, 6, 2, 2);

-- ===============================
-- 6. Методы оплаты (7)
-- ===============================
INSERT INTO Payment_Methods(method_name)
VALUES
('Наличные'),
('Карта'),
('Онлайн'),
('ЮMoney'),
('Кредит');

-- ===============================
-- 7. Доставка (7)
-- ===============================
INSERT INTO Shipping(address, city, postal_code, country)
VALUES
('ул. Ленина, д.1', 'Москва', '101000', 'Россия'),
('пр. Мира, д.10', 'Санкт-Петербург', '190000', 'Россия'),
('ул. Пушкина, д.5', 'Казань', '420000', 'Россия'),
('ул. Лермонтова, д.7', 'Новосибирск', '630000', 'Россия'),
('пр. Гагарина, д.12', 'Екатеринбург', '620000', 'Россия'),
('ул. Чехова, д.3', 'Краснодар', '350000', 'Россия'),
('ул. Толстого, д.8', 'Самара', '443000', 'Россия');

-- ===============================
-- 8. Заказы (7)
-- ===============================
INSERT INTO Orders(customer_id, employee_id, payment_method_id, shipping_id, status)
VALUES
(1,1,2,1,'В обработке'),
(2,2,1,2,'Доставлен'),
(3,3,3,3,'Отменен'),
(4,4,4,4,'В обработке'),
(5,5,5,5,'Доставлен'),
(6,6,6,6,'В обработке'),
(7,7,7,7,'Доставлен');

-- ===============================
-- 9. Товары в заказах (7)
-- ===============================
INSERT INTO Order_Items(order_id, product_id, quantity, price)
VALUES
(1,1,1,90000),
(2,2,2,80000),
(3,3,1,30000),
(4,4,1,40000),
(5,5,1,35000),
(6,6,3,25000),
(7,7,1,200000);

-- ===============================
-- 10. Корзины (7)
-- ===============================
INSERT INTO Cart(customer_id)
VALUES
(1),(2),(3),(4),(5),(6),(7);

-- ===============================
-- 11. Товары в корзине (7)
-- ===============================
INSERT INTO Cart_Items(cart_id, product_id, quantity)
VALUES
(1,2,1),(2,3,2),(3,4,1),(4,5,1),(5,6,2),(6,7,1),(7,8,1);

-- ===============================
-- 12. Отзывы (7)
-- ===============================
INSERT INTO Product_Reviews(product_id, customer_id, rating, comment)
VALUES
(1,1,5,'Отличный телефон!'),
(2,2,4,'Хороший смартфон'),
(3,3,5,'Очень нравится'),
(4,4,3,'Средний'),
(5,5,4,'Нормально'),
(6,6,5,'Рекомендую'),
(7,7,4,'Хороший ноутбук');

-- ===============================
-- 13. Скидки (7)
-- ===============================
INSERT INTO Discounts(name, description, discount_percent, start_date, end_date)
VALUES
('Весенняя акция','Скидка на смартфоны',10,'2026-03-01','2026-03-31'),
('Летняя распродажа','Скидка на ноутбуки',15,'2026-06-01','2026-06-30'),
('Осенняя акция','Скидка на планшеты',20,'2026-09-01','2026-09-30'),
('Зимняя распродажа','Скидка на фотоаппараты',5,'2026-12-01','2026-12-31'),
('Черная пятница','Скидка на все',25,'2026-11-25','2026-11-30'),
('Новогодняя акция','Скидка на телевизоры',30,'2026-12-20','2026-12-31'),
('Весенняя распродажа','Скидка на аксессуары',12,'2026-03-10','2026-03-31');

-- ===============================
-- 14. Связь товаров и скидок (7)
-- ===============================
INSERT INTO Product_Discounts(product_id, discount_id)
VALUES
(1,1),(2,1),(3,3),(4,4),(5,2),(6,5),(7,6);

-- ===============================
-- 15. Списки желаемого (7)
-- ===============================
INSERT INTO Wishlist(customer_id)
VALUES
(1),(2),(3),(4),(5),(6),(7);

-- ===============================
-- 16. Товары в списках желаемого (7)
-- ===============================
INSERT INTO Wishlist_Items(wishlist_id, product_id)
VALUES
(1,3),(2,4),(3,5),(4,6),(5,7),(6,1),(7,2);
ы

-- ХРАНИМЫЕ ПРОЦЕДУРЫ

-- Процедура для создания нового заказа

CREATE OR REPLACE PROCEDURE create_order(
    p_customer_id INT,
    p_employee_id INT,
    p_payment_method_id INT,
    p_shipping_id INT,
    p_items JSON -- [{"product_id":1,"quantity":2},...]
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_order_id INT;
    item JSON;
BEGIN
    -- Создаем заказ
    INSERT INTO Orders(customer_id, employee_id, payment_method_id, shipping_id)
    VALUES (p_customer_id, p_employee_id, p_payment_method_id, p_shipping_id)
    RETURNING order_id INTO new_order_id;

    -- Добавляем товары в Order_Items
    FOR item IN SELECT * FROM json_array_elements(p_items)
    LOOP
        INSERT INTO Order_Items(order_id, product_id, quantity, price)
        VALUES (
            new_order_id,
            (item->>'product_id')::INT,
            (item->>'quantity')::INT,
            (SELECT price FROM Products WHERE product_id=(item->>'product_id')::INT)
        );
        
        -- Уменьшаем количество товара на складе
        UPDATE Products
        SET stock = stock - (item->>'quantity')::INT
        WHERE product_id = (item->>'product_id')::INT;
    END LOOP;
END;
$$;

-- Пример вызова процедуры

CALL create_order(
	1, -- customer_id
    1, -- employee_id
    1, -- payment_method_id
    1, -- shipping_id
    '[
        {"product_id":1,"quantity":2},
        {"product_id":3,"quantity":1}
     ]'::json
);

-- Проверка создания нового заказа

SELECT * FROM Orders ORDER BY order_id DESC;

-- Процедура, позволяющая добавить товар в корзину

CREATE OR REPLACE PROCEDURE add_to_cart(p_customer_id INT, p_product_id INT, p_quantity INT)
LANGUAGE plpgsql
AS $$
DECLARE
    cart_id INT;
BEGIN
    SELECT cart_id INTO cart_id FROM Cart WHERE customer_id=p_customer_id;

    -- Если корзина не существует, создаем
    IF cart_id IS NULL THEN
        INSERT INTO Cart(customer_id) VALUES (p_customer_id) RETURNING cart_id INTO cart_id;
    END IF;

    -- Добавляем товар в Cart_Items
    INSERT INTO Cart_Items(cart_id, product_id, quantity)
    VALUES (cart_id, p_product_id, p_quantity)
    ON CONFLICT (cart_id, product_id) DO UPDATE
    SET quantity = Cart_Items.quantity + EXCLUDED.quantity;
END;
$$;

-- Обновление статуса заказа

CREATE OR REPLACE PROCEDURE update_order_status(p_order_id INT, p_status VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Orders SET status = p_status WHERE order_id = p_order_id;
END;
$$;

-- Создание отзыва на товар

CREATE OR REPLACE PROCEDURE add_product_review(
    p_product_id INT,
    p_customer_id INT,
    p_rating INT,
    p_comment TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Product_Reviews(product_id, customer_id, rating, comment)
    VALUES (p_product_id, p_customer_id, p_rating, p_comment);
END;
$$;

-- Применение скидки к товару

CREATE OR REPLACE PROCEDURE apply_discount_to_product(p_product_id INT, p_discount_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Product_Discounts(product_id, discount_id)
    VALUES (p_product_id, p_discount_id)
    ON CONFLICT DO NOTHING;
END;
$$;

-- ПОЛЬЗОВАТЕЛЬСКИЕ ФУНКЦИИ

-- Позволяет получить общую стоимость заказа

CREATE OR REPLACE FUNCTION get_order_total(p_order_id INT)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT SUM(quantity * price) INTO total
    FROM Order_Items
    WHERE order_id = p_order_id;
    RETURN total;
END;
$$;

-- Позволяет узнать количество товаров в корзине

CREATE OR REPLACE FUNCTION get_cart_count(p_customer_id INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    count INT;
BEGIN
    SELECT SUM(quantity) INTO count
    FROM Cart_Items ci
    JOIN Cart c ON ci.cart_id = c.cart_id
    WHERE c.customer_id = p_customer_id;
    RETURN COALESCE(count, 0);
END;
$$;

-- Позволяет узнать средний рейтинг товара

CREATE OR REPLACE FUNCTION get_product_avg_rating(p_product_id INT)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    avg_rating NUMERIC;
BEGIN
    SELECT AVG(rating) INTO avg_rating
    FROM Product_Reviews
    WHERE product_id = p_product_id;
    RETURN COALESCE(avg_rating, 0);
END;
$$;

-- ИНДЕКСЫ

-- Поиск клиента по email
CREATE INDEX idx_customers_email ON Customers(email);

-- Быстрый поиск заказов по customer_id
CREATE INDEX idx_orders_customer ON Orders(customer_id);

-- Поиск товаров по category
CREATE INDEX idx_products_category ON Products(category_id);

-- Частые join Order_Items → Orders
CREATE INDEX idx_order_items_order ON Order_Items(order_id);

-- Частые join Cart_Items → Cart
CREATE INDEX idx_cart_items_cart ON Cart_Items(cart_id);

-- CTE

-- Вывод 5ти самых продаваемых товаров

WITH TopProducts AS (
    SELECT product_id, SUM(quantity) AS total_sold
    FROM Order_Items
    GROUP BY product_id
)
SELECT p.name, tp.total_sold
FROM TopProducts tp
JOIN Products p ON p.product_id = tp.product_id
ORDER BY tp.total_sold DESC
LIMIT 5;

-- ПОДЗАПРОС

-- Возможность получить все заказы клиента с общей суммой

SELECT o.order_id, o.order_date,
       (SELECT SUM(quantity * price)
        FROM Order_Items oi
        WHERE oi.order_id = o.order_id) AS total
FROM Orders o
WHERE o.customer_id = 1;

-- МОНИТОРИНГ ПРОИЗВОДИТЕЛЬНОСТИ БАЗ ДАННЫХ.

-- Размер таблиц и индексов

SELECT
    relname AS table_name,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
    pg_size_pretty(pg_relation_size(relid)) AS table_size,
    pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) AS indexes_size
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

-- ПРЕДСТАВЛЕНИЯ

-- Общая информация о заказах с клиентами и суммой
CREATE OR REPLACE VIEW v_orders_summary AS
SELECT o.order_id, o.order_date, o.status,
       c.first_name || ' ' || c.last_name AS customer_name,
       SUM(oi.quantity * oi.price) AS total_amount
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date, o.status, c.first_name, c.last_name;

-- Топ-продаваемые товары
CREATE OR REPLACE VIEW v_top_products AS
SELECT p.product_id, p.name, SUM(oi.quantity) AS total_sold
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC;

-- Средний рейтинг товаров
CREATE OR REPLACE VIEW v_product_ratings AS
SELECT p.product_id, p.name, COALESCE(AVG(pr.rating),0) AS avg_rating, COUNT(pr.review_id) AS reviews_count
FROM Products p
LEFT JOIN Product_Reviews pr ON p.product_id = pr.product_id
GROUP BY p.product_id, p.name;

-- ТРИГГЕРЫ

-- Авто-обновление stock при добавлении заказа

CREATE OR REPLACE FUNCTION trg_update_stock()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Products
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_order_items_after_insert
AFTER INSERT ON Order_Items
FOR EACH ROW
EXECUTE FUNCTION trg_update_stock();

-- Автоматическая запись даты изменения в Orders

CREATE OR REPLACE FUNCTION trg_update_order_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.order_date = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_orders_before_update
BEFORE UPDATE ON Orders
FOR EACH ROW
EXECUTE FUNCTION trg_update_order_timestamp();

-- НАСТРОЙКИ БЕЗОПАСНОСТИ

-- Создание роли для неавторизированных пользователей

CREATE ROLE analyst NOLOGIN;

-- Выдача доступа на чтение нужных таблиц

GRANT SELECT ON Customers, Orders, Order_Items, Products, Product_Reviews TO analyst;

-- Роль менеджера

CREATE ROLE manager LOGIN PASSWORD 'manager_pass';

-- Полный доступ на таблицы управления заказами и корзиной
GRANT SELECT, INSERT, UPDATE, DELETE ON Orders, Order_Items, Cart, Cart_Items TO manager;

-- Чтение информации о клиентах и товарах (но не удаление)
GRANT SELECT ON Customers, Products, Categories, Suppliers, Payment_Methods, Shipping TO manager;

-- Доступ к просмотрам (views) для отчетности
GRANT SELECT ON v_orders_summary, v_top_products, v_product_ratings TO manager;






































































































