module BankSimulator

  class WithdrawFundsService
    attr_reader :output, :errors, :messages, :transaction_params

    XML_REQUEST_FILE = Rails.root.join("app/services/bank_simulator/withdraw.xml")

    def initialize(transaction_params)
      @errors = []
      @messages = []
      @transaction_params = transaction_params
    end

    def perform
      # clear old data
      @output = nil
      @errors.clear
      @messages.clear

      # validate transaction data
      return false unless valid_transaction_data?

      # get a token for the transaction
      exchange_for_token

      @errors.empty?
    end

    private

    def valid_transaction_data?
      [
        :amount,
        :bank_token
      ].each do |k|
        @errors << "need to set #{k}" unless @transaction_params.key?(k)
      end

      @transaction_params.each do |k,v|
        if v.blank?
          @errors << "#{k} value is required"
        end
      end

      @errors.empty?
    end

    def exchange_for_token

      begin
        request = WithdrawalRequest.post("/bankSimulator.php?transaction=withdrawal", body: payload)
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
          @errors << "There's been an error making the withdrawal [#{code}: #{status}]"
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
      transaction_hash = Hash.from_xml(xml.to_s)

      # set transaction data
      transaction_hash["withdrawal"]["amount"] = @transaction_params[:amount]
      transaction_hash["withdrawal"]["cardToken"] = @transaction_params[:bank_token]

      transaction_hash["withdrawal"].to_xml(root: "withdrawal").to_s
    end
  end

  class WithdrawalRequest
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