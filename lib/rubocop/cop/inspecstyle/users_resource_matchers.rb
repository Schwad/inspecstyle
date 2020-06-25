# frozen_string_literal: true

# NOTE TO SELF - this one works BUT not if other its statements are defined. Needs
# to work in any arrangement. This is a powerful one to crack as this pattern
# will be used in a LOT of other cops.

module RuboCop
  module Cop
    module InSpecStyle
      # Shadow resource properties `user|password|last_change|expiry_date|line` is deprecated in favor of `users|passwords|last_changes|expiry_dates|lines`
      #
      # @example EnforcedStyle: InSpecStyle (default)
      #   # Use users instead
      #
      #   # bad
      #   describe users('/etc/my-custom-place/users') do
      #     its('has_home_directory?') { should eq 'foo' }
      #   end
      #
      #   # good
      #   describe users('/etc/my-custom-place/users') do
      #     its('users') { should eq 'foo' }
      #   end
      #
      class UsersResourceMatchers < Cop
        include RangeHelp

        MSG = 'Use `:%<solution>s` instead of `:%<violation>s` as a property ' \
        'for the `users` resource. This property will be removed in InSpec 5'

        def_node_matcher :deprecated_users_property?, <<~PATTERN
          (block
            (send _ :its
              (str ${"user" "password" "last_change" "expiry_date" "line"}) ...)
          ...)
        PATTERN

        def_node_matcher :spec?, <<-PATTERN
          (block
            (send nil? :describe ...)
          ...)
        PATTERN

        def_node_matcher :users_resource?, <<-PATTERN
          (block
            (send nil? :describe
              (send nil? :users ...)
            ...)
          ...)
        PATTERN

        def on_block(node)
          return unless inside_users_spec?(node)
          node.descendants.each do |descendant|
            deprecated_users_property?(descendant) do |violation|
              add_offense(
                descendant,
                location: offense_range(descendant),
                message: format(
                  MSG,
                  violation: violation
                )
              )
            end
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.insert_after(offense_range(node), 's')
          end
        end

        private

        def inside_users_spec?(root)
          spec?(root) && users_resource?(root)
        end

        def offense_range(node)
          source = node.children[0].children[-1].loc.expression
          range_between(source.begin_pos+1, source.end_pos-1)
        end
      end
    end
  end
end
