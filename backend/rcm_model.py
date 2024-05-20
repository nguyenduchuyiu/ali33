import numpy as np

batch_size = 10000
data = np.load('backend/assets/similarity_matrices.npz')
similarity_matrices = [data[f'arr_{i}'] for i in range(len(data.files))]

def get_recommendations(movie_id:int):
    try:
        # Determine the batch index and position within the batch
        batch_index = movie_id // batch_size  # Integer division
        position_in_batch = movie_id % batch_size 

        # Load the correct similarity matrix
        similarity_matrix = similarity_matrices[batch_index] 

        # **Adjust the position_in_batch to account for the batch:**
        adjusted_position = position_in_batch + batch_index * batch_size

        # Get similarity scores for the movie
        sim_scores = list(enumerate(similarity_matrix[adjusted_position]))  
        sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
        sim_scores = sim_scores[1:10]  # Get top 15 recommendations

        # Get movie indices for recommendations
        movie_indices = [i[0] for i in sim_scores]
        return movie_indices
    except Exception as e:
        print("error: ", e)
        return []

