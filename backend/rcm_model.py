import numpy as np
import os

batch_size = 10000
data = np.load(os.path.abspath('assets/similarity_matrices.npz'))
similarity_matrices = [data[f'arr_{i}'] for i in range(len(data.files))]

def get_recommendations(movie_id: int):
    try:
        # Determine the batch index and position within the batch
        batch_index = movie_id // batch_size  # Integer division
        position_in_batch = movie_id % batch_size 

        # Load the correct similarity matrix
        similarity_matrix = similarity_matrices[batch_index] 

        # Get similarity scores for the movie (use position_in_batch directly)
        sim_scores = list(enumerate(similarity_matrix[position_in_batch]))
        sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
        sim_scores = sim_scores[1:11]  # Get top 10 recommendations (excluding the movie itself)

        # Get movie indices for recommendations
        movie_indices = [i[0] for i in sim_scores]
        return movie_indices
    except Exception as e:
        print("error: ", e)
        return []