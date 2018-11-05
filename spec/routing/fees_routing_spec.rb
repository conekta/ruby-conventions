require "rails_helper"

RSpec.describe FeesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/fees").to route_to("fees#index")
    end


    it "routes to #show" do
      expect(:get => "/fees/1").to route_to("fees#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/fees").to route_to("fees#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/fees/1").to route_to("fees#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/fees/1").to route_to("fees#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/fees/1").to route_to("fees#destroy", :id => "1")
    end

  end
end
