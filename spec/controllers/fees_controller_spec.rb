require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe FeesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Fee. As you add validations to Fee, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryBot.attributes_for(:fee)
  }

  let(:invalid_attributes) {
    {
      description: nil,
      lower_range: nil,
      upper_range: nil,
      flat_fee: nil,
      variable_fee: nil
    }
  }

  let(:params) { { format: :json } }

  describe "GET #index" do
    let!(:resource) do
      FactoryBot.create(:fee, description: "Fee 1", lower_range: 0, upper_range: 1000, flat_fee: 8, variable_fee: 3)
      FactoryBot.create(:fee, description: "Fee 2", lower_range: 1001, upper_range: 5000, flat_fee: 6, variable_fee: 2.5)
      FactoryBot.create(:fee, description: "Fee 3", lower_range: 5001, upper_range: 10000, flat_fee: 4, variable_fee: 2)
      FactoryBot.create(:fee, description: "Fee 4", lower_range: 10001, upper_range: 99999999.99, flat_fee: 3, variable_fee: 1)
      Fee.all
    end
    subject { get :index, params: params }

    context "Authenticated with admin user" do
      include_context "authenticated user", :admin
      it_behaves_like "paginated endpoint"
      it "returns a success response" do
        subject
        expect(response).to be_success
      end
    end

    context "Authenticated with customer user" do
      include_context "authenticated user", :customer

      it "returns authorization error" do
        subject
        expect(response).to be_forbidden
      end
    end

    context "Not authenticated" do
      it "returns authentication error" do
        subject
        expect(response).to be_unauthorized
      end
    end
  end

  describe "GET #show" do
    let(:fee) { FactoryBot.create(:fee) }
    let(:params) { {id: fee.to_param, format: :json} }
    subject { get :show, params: params }

    context "Authenticated with admin user" do
      include_context "authenticated user", :admin
      it "returns a success response" do
        subject
        expect(response).to be_success
      end
    end

    context "Authenticated with customer user" do
      include_context "authenticated user", :customer

      it "returns authorization error" do
        subject
        expect(response).to be_forbidden
      end
    end

    context "Not authenticated" do
      it "returns authentication error" do
        subject
        expect(response).to be_unauthorized
      end
    end
  end

  describe "POST #create" do
    let(:params) { {fee: valid_attributes, format: :json} }
    subject { post :create, params: params }

    context "Authenticated with admin user" do
      include_context "authenticated user", :admin
      context "with valid params" do
        it "creates a new Fee" do
          expect {
            subject
          }.to change(Fee, :count).by(1)
        end

        it "renders a JSON response with the new fee" do
          subject
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(fee_url(Fee.last))
        end
      end

      context "with invalid params" do
        let(:params) { {fee: invalid_attributes, format: :json} }
        it "renders a JSON response with errors for the new fee" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    context "Authenticated with customer user" do
      include_context "authenticated user", :customer

      it "returns authorization error" do
        subject
        expect(response).to be_forbidden
      end
    end

    context "Not authenticated" do
      it "returns authentication error" do
        subject
        expect(response).to be_unauthorized
      end
    end
  end

  describe "PUT #update" do
    let(:fee) { FactoryBot.create(:fee) }
    let(:new_attributes) { { description: "Another one" }}
    let(:params) { {id: fee.to_param, fee: new_attributes, format: :json} }

    subject { put :update, params: params }
    context "Authenticated with admin user" do
      include_context "authenticated user", :admin
      context "with valid params" do
        it "updates the requested fee" do
          subject
          fee.reload
          expect(json[:description]).to eq(new_attributes[:description])
        end

        it "renders a JSON response with the fee" do
          subject
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context "with invalid params" do
        let(:params) { {id: fee.to_param, fee: invalid_attributes, format: :json} }
        it "renders a JSON response with errors for the fee" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    context "Authenticated with customer user" do
      include_context "authenticated user", :customer

      it "returns authorization error" do
        subject
        expect(response).to be_forbidden
      end
    end

    context "Not authenticated" do
      it "returns authentication error" do
        subject
        expect(response).to be_unauthorized
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:fee) { FactoryBot.create(:fee) }
    let(:params) { {id: fee.id, format: :json} }
    subject { delete :destroy, params: params }
    context "Authenticated with admin user" do
      include_context "authenticated user", :admin
      it "destroys the requested fee" do
        expect {
          subject
        }.to change(Fee, :count).by(-1)
      end
    end

    context "Authenticated with customer user" do
      include_context "authenticated user", :customer

      it "returns authorization error" do
        subject
        expect(response).to be_forbidden
      end
    end

    context "Not authenticated" do
      it "returns authentication error" do
        subject
        expect(response).to be_unauthorized
      end
    end
  end

end
