# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      # @example EnforcedStyle: InSpecStyle (default)
      #   # ppa has been deprecated as a resource. Use apt instead
      #
      class PPAResource < Cop
        MSG = 'Use `apt` instead of `ppa`. '\
              'This resource will be removed in InSpec 5.'

        def_node_matcher :ppa?, <<~PATTERN
          (send _ :ppa ...)
        PATTERN

        def on_send(node)
          return unless ppa?(node)
          add_offense(node, location: :selector)
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(node.loc.selector, preferred_replacement)
          end
        end

        private

        def preferred_replacement
          cop_config.fetch('PreferredReplacement')
        end
      end
    end
  end
end
