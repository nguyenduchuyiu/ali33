import mysql.connector
import pandas as pd

mydb = mysql.connector.connect(
    host="localhost",
    port=3307, 
    user="root",
    password="root", 
    database="ali33_db"
)

mycursor = mydb.cursor()


products = pd.read_csv('data/products.csv')
categories = pd.read_csv('data/categories.csv')
product_categories = pd.read_csv('data/product_categories.csv')
variations = pd.read_csv('data/variations.csv')

product_data = []
for index, row in products.iterrows():
    product_data.append((row[0], row[1], row[2], row[3], row[4]))

category_data = []
for index, row in categories.iterrows():
    category_data.append((row[0], row[1], row[2]))
    
prod_cat_data = []
for index, row in product_categories.iterrows():
    prod_cat_data.append((row[0], row[1]))
    
prod_cat_data_converted = [(int(row[0]), int(row[1])) for row in prod_cat_data]

variation_data = []
for index, row in variations.iterrows():
    variation_data.append((row[0], row[1], row[2], row[3], row[4], row[5], row[6]))

mycursor.executemany("""INSERT INTO products (_key, productName, productDescription, productPicture,
       productRating) VALUES (%s, %s, %s, %s, %s);""", product_data)

mycursor.executemany("""INSERT INTO categories (_key, categoryName, categoryPicture) 
                     VALUES (%s, %s, %s);""", category_data)

mycursor.executemany("""INSERT INTO product_categories (productKey, categoryKey) 
                     VALUES (%s, %s);""", prod_cat_data_converted)

mycursor.executemany("""INSERT INTO variations (_key, productKey, quantity, sellingPrice, discountPrice,
       offerPrice, availabilityQuantity) VALUES (%s, %s, %s, %s, %s, %s, %s);""", variation_data)

mydb.commit()
mydb.close()