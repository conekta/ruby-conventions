RSpec.shared_examples "paginated endpoint" do
  before :each do
    subject
  end

  it "should return the amount of pages" do
    expect(response.headers).to include("X-Total-Pages")
  end

  it "should calculate proper amount of pages" do
    returned_pages = response.headers["X-Total-Pages"].to_i
    max_records = ENV["MAX_RECORDS_PER_PAGE"].to_i
    actual_pages = (resource.count.to_f/max_records).ceil
    actual_pages = actual_pages.zero? ? 1 : actual_pages
    expect(actual_pages).to eq(returned_pages)
  end

  it "should return only #{ENV['MAX_RECORDS_PER_PAGE']} or less records per page" do
    max_records = ENV["MAX_RECORDS_PER_PAGE"].to_i
    expect(json.count).to be <= max_records
  end  
end