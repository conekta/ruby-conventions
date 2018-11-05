module Cards

  class CreateCardService

    attr_reader :output, :errors, :messages, :card_params

    def initialize(card_params, user)
      @errors = []
      @messages = []
      @card_params = card_params
      @user = user
    end

    def perform
      # clear old data
      @output = nil
      @errors.clear
      @messages.clear

      card_args = {
        last_4: card_params[:number].last(4),
        expiration: Date.parse("#{card_params[:expiration_year]}/#{card_params[:expiration_month]}/01"),
        card_type: card_params[:card_type],
        issuer: card_params[:issuer]
      }

      @card = @user.cards.build(card_args)
      return false unless @card.bank_token = generate_bank_token

      if @card.valid?
        @card.save!
        @output = @card
      else
        @errors << @card.errors.full_messages
      end

      @errors.empty?
    end

    def generate_bank_token
      # TODO: Use VCR or something like that to generate requests/responses on specs
      if Rails.env.test?
        Digest::MD5.hexdigest("supersecure")
      else
        service = BankSimulator::AddCardService.new(@card_params)
        if service.perform
          service.output
        else
          @errors.concat(service.errors)
          false
        end
      end
    end

  end
end
