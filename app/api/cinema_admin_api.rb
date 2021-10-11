# frozen_string_literal: true

class CinemaAdminApi < ApiBase
  mount CinemaAdmin::V1::MovieShowings
  mount CinemaAdmin::V1::Prices

  add_swagger_documentation info: {
    title: 'Fast&Furious CinemaAdmin API',
    description: 'A description of the Cinema Appplication API.',
    contact_name: 'Antoni Pstraś'
  }, mount_path: 'v1_admin_swagger.json'
end
