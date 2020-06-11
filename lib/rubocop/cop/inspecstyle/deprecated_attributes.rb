# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module InSpecStyle
      # Checks if deprecated method attribute is used.
      #
      # @example EnforcedStyle: InSpecStyle (default)
      #   # Attributes have been deprecated for inputs
      #   # https://github.com/inspec/inspec/issues/3802
      #
      #   # bad
      #   attribute('my_element', value: 10)
      #
      #   # good
      #   input('my_element', value: 10)
      #
      class DeprecatedAttributes < Cop
        include RangeHelp

        MSG = 'Use `#input` instead of `#attribute`.'

        def_node_matcher :attribute?, <<~PATTERN
          (send nil? :attribute ...)
        PATTERN

        def on_send(node)
          return unless attribute?(node)

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
