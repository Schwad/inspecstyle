# frozen_string_literal: true

RSpec.describe RuboCop::Cop::InSpecStyle::AwsIamUserProperty do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using property `:name`' do
    expect_offense(<<~RUBY)
    describe aws_iam_users do
      its('name') { should eq 'user' }
           ^^^^ Use `:username` instead of `:name` as a property
    end
    RUBY
  end

  it 'registers an offense when using property `:user`' do
    expect_offense(<<~RUBY)
    describe aws_iam_users do
      its('user') { should eq 'user' }
           ^^^^ Use `:aws_user_struct` instead of `:user` as a property
    end
    RUBY
  end
end
