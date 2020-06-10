# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module InSpecStyle
      # Checks if deprecated method attribute is used.
      #
      # @example
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
          add_offense(node, location: range(node))
        end

        private

        def range(node)
          # Only highlights the method 'attribute'
          range_between(
            node.source_range.begin_pos,
            node.source_range.begin_pos+9
          )
        end

        # def autocorrect
        #   ->(corrector) do
        #     corrector.insert_before(node.source_range, 'input')
        #     corrector.remove(node.source_range, 'attribute')
        #   end
        # end
      end
    end
  end
end
