RSpec.describe GoAway do
  it "has a version number" do
    expect(GoAway::VERSION).not_to be nil
  end

  context 'when current user is not defined' do
    let(:test_class) do
      class TestClass
        include GoAway

        def call
          authorize :invalid
        end
      end
    end

    it 'raises an error' do
      expect(test_class.new.call).to raise_error('dupa')
    end
  end # current user not defined

  context 'when current user is defined' do
  end # current user is defined
end
