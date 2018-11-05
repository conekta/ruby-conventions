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

RSpec.describe CardsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Card. As you add validations to Card, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      "name_on_card": "John Doe",
      "number": "4111111111111111",
      "csc": "123",
      "expiration_year": "2020",
      "expiration_month": "06",
      "card_type": "credit",
      "issuer": "visa"
    }
  }

  let(:invalid_attributes) {
    {
      "name_on_card": nil,
      "number": nil,
      "csc": nil,
      "expiration_year": nil,
      "expiration_month": nil,
      "card_type": nil,
      "issuer": nil
    }
  }

  let(:user) { FactoryBot.create(:user) }

  describe "GET #index" do
    let!(:resource) { FactoryBot.create_list(:user_with_cards, 5) }
    let!(:user) { resource.first }
    let(:params) { { format: :json, user_id: user.id } }
    subject { get :index, params: params }

    context "Authenticated with admin user" do
      include_context "authenticated user", :admin

      it_behaves_like "paginated endpoint"
      it "returns a success response" do
        subject
        expect(response).to be_success
        expect(json.count).to eq(user.cards.count)
      end

      context "when there are removed cards" do
        before :each do
          user.cards.first.removed!
        end

        it "returns both active and removed cards" do
          subject
          expect(json.count).to eq(user.cards.count)
        end
      end
    end

    context "Authenticated with customer user" do
      include_context "authenticated user", :customer

      context "for authorized user" do
        let(:params) { { user_id: authenticated_user.id, format: :json } }
        let!(:cards) { FactoryBot.create_list(:card, 4, user: authenticated_user) }

        it "returns a success response" do
          subject
          expect(response).to be_success
          expect(json.count).to eq(authenticated_user.cards.active.count)
        end

        context "when there are removed cards" do
          before :each do
            authenticated_user.cards.first.removed!
          end

          it "returns only active cards" do
            subject
            expect(json.count).to eq(authenticated_user.cards.active.count)
          end
        end
      end

      context "for unauthorized user" do
        it "returns authorization error" do
          subject
          expect(response).to be_forbidden
        end
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
    let!(:card) { FactoryBot.create(:card, user: user) }
    let(:params) { { user_id: user.id, id: card.id, format: :json } }
    subject { get :show, params: params }

    context "Authenticated with admin user" do
      include_context "authenticated user", :admin
      it "returns a success response" do
        subject
        expect(response).to be_success
      end

      context "when card had transactions and was removed" do
        let!(:transaction) { FactoryBot.create(:transaction, transaction_type: Transaction.transaction_types[:withdrawal], transferable: card) }

        before :each do
          card.removed!
        end

        it "still returns the card resource" do
          subject
          expect(response).to be_success
          expect(json[:id]).to eq(card.id)
          expect(json[:status]).to eq('removed')
        end
      end
    end

    context "Authenticated with customer user" do
      include_context "authenticated user", :customer

      context "for authorized user" do
        let!(:card) { FactoryBot.create(:card, user: authenticated_user) }
        let(:params) { { user_id: authenticated_user.id, id: card.id, format: :json } }

        it "returns a success response" do
          subject
          expect(response).to be_success
        end

        context "when card had transactions and was removed" do
          let!(:transaction) { FactoryBot.create(:transaction, transaction_type: Transaction.transaction_types[:withdrawal], transferable: card) }

          before :each do
            card.removed!
          end

          it "it returns an error" do
            subject
            expect(response).to be_forbidden
          end
        end
      end

      context "for unauthorized user" do
        it "returns authorization error" do
          subject
          expect(response).to be_forbidden
        end
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
    let(:params) { { user_id: user.id, card: valid_attributes, format: :json } }
    subject { post :create, params: params }

    context "Authenticated with admin user" do
      include_context "authenticated user", :admin

      context "with valid params" do
        it "creates a new Card" do
          expect { subject }.to change(Card, :count).by(1)
        end

        it "renders a JSON response with the new card" do
          subject
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(user_cards_url(Card.last.user, Card.last))
        end
      end

      context "with invalid params" do
        let(:params) { { user_id: user.id, card: invalid_attributes, format: :json } }
        it "renders a JSON response with errors for the new card" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end

    context "Authenticated with customer user" do
      include_context "authenticated user", :customer

      context "for authorized user" do
        let(:params) { { user_id: authenticated_user.id, card: valid_attributes, format: :json } }
        it "returns a success response" do
          subject
          expect(response).to be_success
        end
      end

      context "for unauthorized user" do
        it "returns authorization error" do
          subject
          expect(response).to be_forbidden
        end
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
    let!(:card) { FactoryBot.create(:card, user: user) }
    let(:params) { { user_id: user.id, id: card.id, format: :json } }
    subject { delete :destroy, params: params }

    context "Authenticated with admin user" do
      include_context "authenticated user", :admin
      it "destroys the requested card" do
        expect { subject }.to change(Card, :count).by(-1)
      end

      context "when card has transactions" do
        let!(:transaction) { FactoryBot.create(:transaction, transaction_type: Transaction.transaction_types[:withdrawal], transferable: card) }

        it "only marks card as removed" do
          expect { subject }.to_not change(Card, :count)
          expect(user.cards.removed).to include(card)
          expect(card.reload.removed?).to be true
        end
      end
    end

    context "Authenticated with customer user" do
      include_context "authenticated user", :customer

      context "for authorized user" do
        let!(:card) { FactoryBot.create(:card, user: authenticated_user) }
        let(:params) { { user_id: authenticated_user.id, id: card.id, format: :json } }
        it "returns a success response" do
          subject
          expect(response).to be_success
        end

        context "when card has transactions" do
          let!(:transaction) { FactoryBot.create(:transaction, transaction_type: Transaction.transaction_types[:withdrawal], transferable: card) }

          it "only marks card as removed" do
            expect { subject }.to_not change(Card, :count)
            expect(authenticated_user.cards.removed).to include(card)
            expect(card.reload.removed?).to be true
          end
        end
      end

      context "for unauthorized user" do
        it "returns authorization error" do
          subject
          expect(response).to be_forbidden
        end
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
