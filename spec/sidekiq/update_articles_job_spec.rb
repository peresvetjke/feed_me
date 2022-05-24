require 'rails_helper'
RSpec.describe UpdateArticlesJob, type: :job do
  let(:service) { UpdatesManager.new }
  
  it "calls UpdatesManager" do
    allow(UpdatesManager).to receive(:new).and_return(service)
    expect(service).to receive(:call)
    subject.perform
  end
end
