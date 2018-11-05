require "rails_helper"

RSpec.describe CardsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "users/1/cards").to route_to("cards#index", user_id: "1")
    end

    it "routes to #show" do
      expect(:get => "users/1/cards/1").to route_to("cards#show", user_id: "1", id: "1")
    end

    it "routes to #create" do
      expect(:post => "users/1/cards").to route_to("cards#create", user_id: "1")
    end

    it "routes to #destroy" do
      expect(:delete => "users/1/cards/1").to route_to("cards#destroy", user_id: "1", id: "1")
    end

  end
end
