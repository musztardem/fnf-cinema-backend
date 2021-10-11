# frozen_string_literal: true

movie_ids = %w[
  tt0232500
  tt0322259
  tt0463985
  tt1013752
  tt1596343
  tt1905041
  tt2820852
  tt4630562
]

movie_ids.map { |movie_id| Movie.create!(id: movie_id) }
