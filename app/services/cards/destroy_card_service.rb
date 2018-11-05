module Cards

  class DestroyCardService

    attr_reader :output, :errors, :messages, :card

    def initialize(card)
      @errors = []
      @messages = []
      @card = card
    end

    def perform
      # clear old data
      @output = nil
      @errors.clear
      @messages.clear

      if @card.has_transactions?
        @card.removed!
      else
        @errors << @card.errors.full_messages unless @card.destroy
      end

      @errors.empty?
    end
  end
end
