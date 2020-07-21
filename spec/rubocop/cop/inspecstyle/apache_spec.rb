# frozen_string_literal: true

RSpec.describe RuboCop::Cop::InSpecStyle::Apache do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `apache`' do
    expect_offense(<<~RUBY)
    describe apache do
             ^^^^^^ Use `apache_conf` instead of `#apache`.
      it('true') { should eq true }
    end
    RUBY
  end

  it 'does not register an offense when using `apache_conf`' do
    expect_no_offenses(<<~RUBY)
      describe apache_conf do; end
    RUBY
  end
end
