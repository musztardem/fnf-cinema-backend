# frozen_string_literal: true

module Cinema
  module Entities
    class Showing < Grape::Entity
      expose :id, documentation: { type: Integer, required: true, desc: 'Showings ID', example: 342 }
      expose :movie_id, documentation: { type: String, required: true, desc: 'Movie ID', example: 'tt5157242' }
      expose :projection_date,
             documentation: { type: String, required: true, desc: 'Date and time when movie is going to be played',
                              example: '2022-03-03 20:15:53' }
    end
  end
end
