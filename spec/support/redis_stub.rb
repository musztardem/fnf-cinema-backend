# frozen_string_literal: true

class RedisStub
  def initialize
    @db = {}
  end

  def mset(*params)
    @db = @db.merge(params.each_slice(2).to_h)

    'OK'
  end

  def mget(*keys)
    keys.map { |key| @db[key] }
  end
end
