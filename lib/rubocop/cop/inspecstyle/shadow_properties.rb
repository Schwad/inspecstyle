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
        include RangeHelp

        MSG = 'Use `:%<violation>ss` instead of `:%<violation>s` as a property ' \
        'for the `shadow` resource. This property will be removed in InSpec 5'

        def_node_matcher :deprecated_shadow_property?, <<~PATTERN
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

        def_node_matcher :shadow_resource?, <<-PATTERN
          (block
            (send nil? :describe
              (send nil? :shadow ...)
            ...)
          ...)
        PATTERN

        def on_block(node)
          return unless inside_shadow_spec?(node)
          node.descendants.each do |descendant|
            deprecated_shadow_property?(descendant) do |violation|
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

        def inside_shadow_spec?(root)
          spec?(root) && shadow_resource?(root)
        end

        def offense_range(node)
          source = node.children[0].children[-1].loc.expression
          range_between(source.begin_pos+1, source.end_pos-1)
        end
      end
    end
  end
end
