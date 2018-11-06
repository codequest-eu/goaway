require "ostruct"
RSpec.describe GoAway do
  it "has a version number" do
    expect(GoAway::VERSION).not_to be nil
  end

  context 'when current user is not defined' do
    let(:test_class) do
      Class.new do
        include GoAway

        def call
          authorize :invalid
          'TRUE'
        end
      end
    end

    it 'raises an error' do
      expect { test_class.new.call }.to raise_error(GoAway::CurrentUserError)
    end
  end # current user not defined

  context 'when current user is defined' do
    context 'in the base class' do
      let(:test_class) do
        Class.new do
          include GoAway

          def call
            authorize :authorized_user
            'TRUE'
          end

          def current_user
            OpenStruct.new(authorized_user?: true)
          end
        end
      end

      it 'does not raise an error' do
        expect { test_class.new.call }.to_not raise_error()
      end

      it 'allows user to perform action' do
        expect(test_class.new.call).to eq('TRUE')
      end
    end # in base class

    context 'in another module' do
      TestModule = Module.new do
        def current_user
          OpenStruct.new(authorized_user?: true)
        end
      end

      let(:test_class) do
        Class.new do
          include TestModule
          include GoAway

          def call
            authorize :authorized_user
            'TRUE'
          end
        end
      end

      it 'does not raise an error' do
        expect { test_class.new.call }.to_not raise_error()
      end

      it 'allows user to perform action' do
        expect(test_class.new.call).to eq('TRUE')
      end
    end # in another module
  end # current user is defined
end
