module Concerns
  module Paginable

    extend ActiveSupport::Concern

    included do
      scope :page, ->(page) { limit(ENV['MAX_RECORDS_PER_PAGE'].to_i).offset((page*ENV['MAX_RECORDS_PER_PAGE'].to_i)-ENV['MAX_RECORDS_PER_PAGE'].to_i) }
    end

    class_methods do
      def pages
        total = self.count
        page_count = (total.to_f / ENV['MAX_RECORDS_PER_PAGE'].to_i).ceil
        page_count = page_count.zero? ? 1 : page_count
      end
    end
  end
end