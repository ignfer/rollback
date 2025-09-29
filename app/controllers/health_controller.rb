class HealthController < ApplicationController
  def index
    db_ok =
      begin
        ActiveRecord::Base.connection.execute("SELECT 1")
        true
      rescue
        false
      end

    render json: {
      status: "ok",
      ruby: RUBY_VERSION,
      rails: Rails::VERSION::STRING,
      db: db_ok
    }
  end
end
