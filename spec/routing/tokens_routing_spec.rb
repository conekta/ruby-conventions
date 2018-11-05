require "rails_helper"

RSpec.describe TokensController, type: :routing do
  describe "routing" do

    it "routes to #create" do
      expect(:post => "/tokens").to route_to("tokens#create")
    end

    it "routes to #show" do
      expect(:get => "/tokens/1").to route_to("tokens#show", :id => "1")
    end

  end
end
