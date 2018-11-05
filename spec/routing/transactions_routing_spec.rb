require "rails_helper"

RSpec.describe TransactionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "users/1/transactions").to route_to("transactions#index", user_id: "1")
    end


    it "routes to #show" do
      expect(:get => "users/1/transactions/1").to route_to("transactions#show", user_id: "1", id: "1")
    end


    it "routes to #create" do
      expect(:post => "users/1/transactions").to route_to("transactions#create", user_id: "1")
    end

  end
end
