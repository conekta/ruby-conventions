class VersionsController < ApplicationController

  skip_before_action :authenticate

  def index
    version = {
      level: "info",
      message: "This is an API application. Please check the documents to interact with it.",
      data: {
        version: {
          major: 1,
          minor: 0,
          revision: 0
        }
      }
    }
    render json: version, status: 200
  end

end
