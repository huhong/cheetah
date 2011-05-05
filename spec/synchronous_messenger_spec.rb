require 'spec_helper'

describe Cheetah::SynchronousMessenger do

  context "#send" do
    before do
      @messenger = Cheetah::SynchronousMessenger.instance
      @message   = Message.new("/",{})
      @resp      = mock(:resp).as_null_object
      @http      = mock(:http).as_null_object
      @http.stub(:post).and_return(@resp)
      Net::HTTP.stub(:new).and_return(@http)
    end

    it "should send a http post" do
      @http.should_receive(:post)
      @messenger.send(@message)
    end

    it "should raise CheetahPermanentException when there's an authorization problem" do
      @resp.stub(:code).and_return('200')
      @resp.stub(:body).and_return('err:auth')
      lambda { @messenger.send(@message) }.should raise_error(CheetahPermanentException)
    end

    it "should raise CheetahPermanentException when there's a permanent error on Cheetah's end" do
      @resp.stub(:code).and_return('400')
      lambda { @messenger.send(@message) }.should raise_error(CheetahPermanentException)
    end

    it "should raise CheetahTemporaryException when there's a temporary error on Cheetah's end" do
      @resp.stub(:code).and_return('500')
      lambda { @messenger.send(@message) }.should raise_error(CheetahTemporaryException)
    end

    it "should raise CheetahTemporaryException when there's a temporary error on Cheetah's end" do
      @resp.stub(:code).and_return('200')
      @resp.stub(:body).and_return('err:internal error')
      lambda { @messenger.send(@message) }.should raise_error(CheetahTemporaryException)
    end

  end

end
