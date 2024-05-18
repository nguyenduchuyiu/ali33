import pandas as pd
import pyarrow as pa

master_dataset = pd.read_parquet('backend/assets/movie_database.parquet')
table = pa.parquet.read_table('backend/assets/model.parquet').to_pandas()

master_dataset = master_dataset.reset_index()
titles = master_dataset['title']
indices = pd.Series(master_dataset.index, index=master_dataset['title'])

def get_recommendations(movie_id_from_db,movie_db) -> list:
    try:
        sim_scores = list(enumerate(movie_db[movie_id_from_db]))
        sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
        sim_scores = sim_scores[1:15] ## get top 15 Recommendations
        
        movie_indices = [i[0] for i in sim_scores]
        output = master_dataset.iloc[movie_indices]
        output.reset_index(inplace=True, drop=True)

        response = []
        for i in range(len(output)):
            response.append(output['title'].iloc[i])
        return response
    except Exception as e:
        print("error: ",e)
        return []

def get_related_products(products_name:list) -> list:
    try:
        product_index = titles.to_list().index(products_name)
        recommendations = get_recommendations(product_index,table)
        return recommendations
    except:
        return []
