# frozen_string_literal: true

# NOTE TO SELF - this one works BUT not if other its statements are defined. Needs
# to work in any arrangement. This is a powerful one to crack as this pattern
# will be used in a LOT of other cops.

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
        MSG = 'Use `:%<modifier>ss` instead of `:%<modifier>s` as a property ' \
        'for the `shadow` resource. This property will be removed in InSpec 5'

        def_node_matcher :shadow_resource_user_property?, <<~PATTERN
          (block
            (send _ :describe
              (send _ :shadow ...) ...)
            (args ...)
            (block
              (send _ :its
                (str ${"user" "password" "last_change" "expiry_date" "line"} ...) ...) ...) ...)
        PATTERN

        def_node_matcher :shadow_resource_user_property_begin?, <<~PATTERN
          (block
            (send _ :describe
              (send _ :shadow ...) ...)
            (args ...)
            (begin
              (block
                (send _ :its
                  (str ${"user" "password" "last_change" "expiry_date" "line"} ...) ...) ...) ...) ...)
        PATTERN

        def on_block(node)
          if shadow_resource_user_property?(node)
            shadow_resource_user_property?(node) do |modifier|
              message = format(MSG, modifier: modifier)
              range = locate_range(modifier, node)
              add_offense(node, message: message, location: range)
            end
          elsif shadow_resource_user_property_begin?(node)
            # I believe I need a different matcher if there's other material in the block. This does not work yet
            shadow_resource_user_property_begin? do |modifier|
              message = format(MSG, modifier: modifier)
              range = locate_range(modifier, node)
              add_offense(node, message: message, location: range)
            end
          end
        end

        private

        def locate_range(modifier, node)
          node.children.find { |child| child.type == :block }.children.first.children.find{|x| x == s(:str, modifier)}.source_range
        end
      end
    end
  end
end
