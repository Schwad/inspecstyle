# frozen_string_literal: true

# NOTE TO SELF - this one isn't currently working even though my pattern works in Rubocop's bin/console

module RuboCop
  module Cop
    module InSpecStyle
      # Shadow resource property user is deprecated in favor of `users`
      #
      # @example EnforcedStyle: InSpecStyle (default)
      #   # Use users instead
      #
      #   # bad
      #   describe shadow('/etc/my-custom-place/shadow') do
      #     its('user') { should eq 'user' }
      #   end
      #
      #   # good
      #   describe shadow('/etc/my-custom-place/shadow') do
      #     its('users') { should eq 'user' }
      #   end
      #
      class ShadowProperties < Cop
        # TODO: Implement the cop in here.
        #
        # In many cases, you can use a node matcher for matching node pattern.
        # See https://github.com/rubocop-hq/rubocop-ast/blob/master/lib/rubocop/node_pattern.rb
        #
        # For example
        MSG = 'Use `#users` instead of `#user`. This property will be removed '\
              'in InSpec 5'

        def_node_matcher :shadow_resource_user_property?, <<~PATTERN
          (block
            (send _ :describe
              (send _ :shadow ...) ...)
            (args ...)
            (block
              (send _ :its
                (str ${"user" "password" "last_change" "expiry_date" "line"} ...) ...) ...) ...)
        PATTERN

        def on_send(node)
          return unless shadow_resource_user_property?(node)
          require 'pry'
          binding.pry
          add_offense(node)
        end
      end
    end
  end
end
