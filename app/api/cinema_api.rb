# frozen_string_literal: true

class CinemaApi < ApiBase
  mount Cinema::V1::Movies
  mount Cinema::V1::MovieShowings
  mount Cinema::V1::MovieRatings
  mount Cinema::V1::Users

  add_swagger_documentation info: {
    title: 'Fast&Furious Cinema API',
    description: 'A description of the Cinema Appplication API.',
    contact_name: 'Antoni Pstraś'
  }, mount_path: 'v1_swagger.json'
end
