require "vagrant-managed-servers/config"

describe VagrantPlugins::ManagedServers::Config do
  let(:instance) { described_class.new }

  # Ensure tests are not affected by AWS credential environment variables
  before :each do
    ENV.stub(:[] => nil)
  end

  describe "defaults" do
    subject do
      instance.tap do |o|
        o.finalize!
      end
    end

    its("server")     { should be_nil }
  end

  describe "overriding defaults" do
    it "should not default server if overridden" do
      instance.server = "foo"
      instance.finalize!
      instance.server.should == "foo"
    end
  end
end
