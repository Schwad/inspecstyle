# frozen_string_literal: true

# NOTE TO SELF - this one works BUT not if other its statements are defined. Needs
# to work in any arrangement. This is a powerful one to crack as this pattern
# will be used in a LOT of other cops.

module RuboCop
  module Cop
    module InSpecStyle
      # Users resource deprecated matchers
      #
      # @example EnforcedStyle: InSpecStyle (default)
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
        MSG = 'Use `%<solution>s` instead of `%<violation>s` as a matcher ' \
        "for the `users` resource. \nThis matcher will be removed in InSpec 5"

        MAP = {
            has_home_directory?: "its('home')",
            has_login_shell?: "its('shell')",
            has_authorized_key?: "another matcher",
            maximum_days_between_password_change: :maxdays,
            has_uid?: "another matcher",
            minimum_days_between_password_change: "mindays"
          }

        def_node_matcher :deprecated_users_matcher?, <<~PATTERN
          (send _ ${#{MAP.keys.map(&:inspect).join(' ')}} ...)
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
            deprecated_users_matcher?(descendant) do |violation|
              add_offense(
                descendant,
                location: offense_range(descendant),
                message: format(
                  MSG,
                  violation: violation,
                  solution: MAP[violation]
                )
              )
            end
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            # Only these two matchers are autocorrectable
            [
              'maximum_days_between_password_change',
              'minimum_days_between_password_change'
            ].map do |violation|
              if node.inspect.include?(violation)
                corrector.replace(node.loc.selector, MAP[violation.to_sym])
              end
            end
          end
        end

        private

        def inside_users_spec?(root)
          spec?(root) && users_resource?(root)
        end

        def offense_range(node)
          node.loc.selector
        end
      end
    end
  end
end
