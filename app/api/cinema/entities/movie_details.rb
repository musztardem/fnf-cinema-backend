# frozen_string_literal: true

module Cinema
  module Entities
    class MovieDetails < Grape::Entity
      expose :imdb_id, documentation: { type: String, required: true, desc: 'Movie ID from IMDB', example: 'tt5157242' }
      expose :title,
             documentation: { type: String, required: true, desc: 'Movies title',
                              example: 'Scarred: Plastic Surgery Gone Very Wrong!' }
      expose :plot,
             documentation: { type: String, required: true, desc: 'Movies plot description',
                              example: 'A controversial procedure that claims to fix depression during a lunch break' }
      expose :released, documentation: { type: String, required: true, desc: 'Release date', example: '03 Nov 2015' }
      expose :imdb_rating,
             documentation: { type: String, required: true, desc: 'Movies rating from IMDB', example: 'N/A' }
      expose :runtime, documentation: { type: String, required: true, desc: 'Runtime', example: '60 min' }
      expose :users_rating, documentation: { type: String, required: true, desc: 'Users rating', example: '3.0' }
    end
  end
end
