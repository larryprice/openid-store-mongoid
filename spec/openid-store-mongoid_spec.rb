require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module OpenID::Store
  describe MongoidStore do
    before :all do
      @store = MongoidStore.new
    end

    describe '#new' do
      it 'has type OpenID::Store::Interface' do
        @store.should be_kind_of OpenID::Store::Interface
      end
    end

    describe '#get_association' do
      it 'returns nil if no associations found and no handle given' do
        server_url = 'test/url'
        Association.should_receive(:where).with({:server_url => server_url}).once.and_return(Array.new)

        @store.get_association(server_url).should be_nil
      end

      it 'returns nil if no associations found and handle given' do
        server_url = 'test/url'
        handle = 'test/handle'
        Association.should_receive(:where).with({:server_url => server_url, :handle => handle}).once.and_return(Array.new)

        @store.get_association(server_url, handle).should be_nil
      end

      it 'returns nil if all associations have expired' do
        openid_assn1 = double("OpenID::Association")
        openid_assn1.should_receive(:expires_in).once.and_return(0)
        openid_assn2 = double("OpenID::Association")
        openid_assn2.should_receive(:expires_in).once.and_return(0)

        assn1 = double("Association")
        assn1.should_receive(:from_record).once.and_return(openid_assn1)
        assn1.should_receive(:destroy).once
        assn2 = double("Association")
        assn2.should_receive(:from_record).once.and_return(openid_assn2)
        assn2.should_receive(:destroy).once

        server_url = 'test/url'
        Association.should_receive(:where).with({:server_url => server_url}).once.and_return([assn1, assn2])

        @store.get_association(server_url).should be_nil
      end

      it 'returns first unexpired association' do
        openid_assn1 = double("OpenID::Association")
        openid_assn1.should_receive(:expires_in).once.and_return(1)
        openid_assn2 = double("OpenID::Association")
        openid_assn2.should_receive(:expires_in).once.and_return(0)

        assn1 = double("Association")
        assn1.should_receive(:from_record).once.and_return(openid_assn1)
        assn1.should_receive(:destroy).never
        assn2 = double("Association")
        assn2.should_receive(:from_record).once.and_return(openid_assn2)
        assn2.should_receive(:destroy).once

        server_url = 'test/url'
        Association.should_receive(:where).with({:server_url => server_url}).once.and_return([assn1, assn2])

        @store.get_association(server_url).should eql openid_assn1
      end
    end

    describe '#store_association' do
      it 'removes no associations and creates new association when no match' do
        server_url = 'server/url'

        openid_assn = OpenID::Association.new('/some/handle', 'secret', Time.now, 10, 'some/type')

        Association.any_instance.should_receive(:destroy).never
        Association.should_receive(:where).with({:server_url => server_url, :handle => openid_assn.handle})
                                          .once.and_return(Array.new)
        Association.should_receive(:create)
                   .with(:server_url => server_url, :handle => openid_assn.handle,
                         :secret => Moped::BSON::Binary.new(:generic, openid_assn.secret),
                         :issued => openid_assn.issued.to_i, :lifetime => openid_assn.lifetime,
                         :assoc_type => openid_assn.assoc_type)
                   .once

        @store.store_association(server_url, openid_assn)
      end

      it 'removes any matching associations and creates new association' do
        server_url = 'server/url'

        assn1 = double("Association")
        assn1.should_receive(:destroy!).once
        assn2 = double("Association")
        assn2.should_receive(:destroy!).never
        assn3 = double("Association")
        assn3.should_receive(:destroy!).once

        openid_assn = OpenID::Association.new('/some/handle', 'secret', Time.now, 10, 'some/type')

        Association.any_instance.should_receive(:destroy).never
        Association.should_receive(:where).with({:server_url => server_url, :handle => openid_assn.handle})
                                          .once.and_return([assn1, assn3])
        Association.should_receive(:create)
                   .with(:server_url => server_url, :handle => openid_assn.handle,
                         :secret => Moped::BSON::Binary.new(:generic, openid_assn.secret),
                         :issued => openid_assn.issued.to_i, :lifetime => openid_assn.lifetime,
                         :assoc_type => openid_assn.assoc_type)
                   .once

        @store.store_association(server_url, openid_assn)
      end
    end

    describe '#use_nonce' do
      it 'returns false if any matching nonces found' do
        server_url = 'some/url'
        timestamp = Time.now
        salt = 'qwerty12345'

        Nonce.should_receive(:where).with(:server_url => server_url, :timestamp => timestamp, :salt => salt)
             .once.and_return([double("Association")])

        @store.use_nonce(server_url, timestamp, salt).should be_false
      end

      it 'returns false if time is beyond skew and no matching nonces found' do
        now = Time.now
        timestamp = now + OpenID::Nonce.skew + 1

        server_url = 'some/url'
        salt = 'qwerty12345'

        Nonce.should_receive(:where).with(:server_url => server_url, :timestamp => timestamp, :salt => salt)
             .once.and_return(Array.new)
        Time.should_receive(:now).once.and_return(now)

        @store.use_nonce(server_url, timestamp, salt).should be_false
      end

      it 'returns true and creates nonce if no matching nonces and time within skew' do
        now = Time.now
        timestamp = now + OpenID::Nonce.skew - 1

        server_url = 'some/url'
        salt = 'qwerty12345'

        Nonce.should_receive(:where).with(:server_url => server_url, :timestamp => timestamp, :salt => salt)
             .once.and_return(Array.new)
        Nonce.should_receive(:create).with(:server_url => server_url, :timestamp => timestamp, :salt => salt).once
        Time.should_receive(:now).once.and_return(now)

        @store.use_nonce(server_url, timestamp, salt).should be_true
      end
    end
  end
end

