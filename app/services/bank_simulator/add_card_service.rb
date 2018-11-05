module BankSimulator

  class AddCardService
    attr_reader :output, :errors, :messages, :card_params

    XML_REQUEST_FILE = Rails.root.join("app/services/bank_simulator/card.xml")

    def initialize(card_params)
      @errors = []
      @messages = []
      @card_params = card_params
    end

    def perform
      # clear old data
      @output = nil
      @errors.clear
      @messages.clear

      # validate card data
      return false unless valid_card_data?

      # get a token for the added card
      exchange_for_token

      @errors.empty?
    end

    private

    def valid_card_data?
      [
        :name_on_card,
        :number,
        :csc,
        :expiration_year,
        :expiration_month
      ].each do |k|
        @errors << "need to set #{k}" unless @card_params.key?(k)
      end

      @card_params.each do |k,v|
        if v.blank?
          @errors << "#{k} value is required"
        end
      end

      @errors.empty?
    end

    def exchange_for_token
      begin
        request = AddCardRequest.post("/bankSimulator.php?transaction=card", body: payload)
      rescue StandardError => e
        raise ApiErrors::BadGatewayError.new("There has been an error contacting the bank. Please contact support!")
      end

      # validate response
      if request.response.code == "200"
        xml = request.response.body
        response_object = Hash.from_xml(xml)

        code = response_object["transaction"]["code"]
        reference = response_object["transaction"]["reference"]
        status = response_object["transaction"]["status"]

        # typical of shitty banks to return 200 for everything and status codes within responses so here we go
        if code != "1000"
          @errors << "There's been an error adding your card [#{code}: #{status}]"
        else
          @output = reference
        end
      else
        # this is could be an authentication/authorization (401/403) error, misconfiguration or something else
        # basically anything on the 5xx status codes and there is nothing the user can do really
        raise ApiErrors::BadGatewayError.new("There has been an error contacting the bank. Please contact support!")
      end
    end

    def payload
      file = File.open(XML_REQUEST_FILE)
      xml = Nokogiri::XML(file)
      card_hash = Hash.from_xml(xml.to_s)

      # set card data
      card_hash["card"]["cardHolder"] = @card_params[:name_on_card]
      card_hash["card"]["number"] = @card_params[:number]
      card_hash["card"]["expirationMonth"] = @card_params[:expiration_month]
      card_hash["card"]["expirationYear"] = @card_params[:expiration_year]
      card_hash["card"]["csc"] = @card_params[:csc]

      card_hash["card"].to_xml(root: "card").to_s
    end
  end

  class AddCardRequest
    include HTTParty

    basic_auth(ENV["BANK_SIMULATOR_USERNAME"], ENV["BANK_SIMULATOR_PASSWORD"])
    base_uri(ENV["BANK_SIMULATOR_URI"])
    headers({
        "Accept" => "application/xml",
        "Content-Type" => "application/xml",
        "Cache-Contol" => "no-cache"
      })
  end

end