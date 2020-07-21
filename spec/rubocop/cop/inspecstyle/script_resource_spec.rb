# frozen_string_literal: true

RSpec.describe RuboCop::Cop::InSpecStyle::ScriptResource do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  # TODO: Write test code
  #
  # For example
  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
    describe script(`exec wutup`) do
             ^^^^^^ Use `apache_conf` instead of `#apache`.
      it('true') { should eq true }
    end
    RUBY
  end

  it 'does not register an offense when using `#good_method`' do
    expect_no_offenses(<<~RUBY)
      good_method
    RUBY
  end
end
