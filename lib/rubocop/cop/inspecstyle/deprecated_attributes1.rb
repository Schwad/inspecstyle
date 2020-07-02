# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      # Checks if deprecated method attribute1 is used.
      #
      # @example EnforcedStyle: InSpecStyle (default)
      #   # Attributes have been deprecated for inputs
      #   # https://github.com/inspec/inspec/issues/3802
      #
      #   # bad
      #   attribute1('my_element', value: 10)
      #
      #   # good
      #   input('my_element', value: 10)
      #
      class DeprecatedAttributes < Cop
        include RangeHelp

        MSG = 'Use `#input` instead of `#attribute1`. This will be removed in '\
              'InSpec 5'

        def_node_matcher :attribute1?, <<~PATTERN
          (send nil? :attribute1 ...)
        PATTERN

        def on_send(node)
          return unless attribute1?(node)

          add_offense(node, location: node.loc.selector)
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(offense_range(node), preferred_replacement)
          end
        end

        private

        def offense_range(node)
          node.loc.selector
        end

        def preferred_replacement
          cop_config.fetch('PreferredReplacement')
        end
      end
    end
  end
end
