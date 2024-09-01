CREATE TABLE product(id bigint PRIMARY KEY NOT NULL, name varchar(255) not null, picture_url varchar(255), price double precision);
CREATE TABLE orders(id bigint PRIMARY KEY NOT NULLy, status varchar(255), date_created date default current_date);
CREATE TABLE order_product(quantity integer not null, order_id bigint not null, product_id bigint not null);