# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      # Do not use apache
      #
      # @example EnforcedStyle: InSpecStyle (default)
      #   # apache has been deprecated
      #   # 'https://github.com/inspec/inspec/issues/3131'
      #   # Since there are multiples replacements autocorrect is not supported.
      #
      #   # bad
      #   apache
      #
      #   # good
      #   azurerm_virtual_machine # use a specific resource pack resource
      #
      class Apache < Cop
        MSG = 'Use `apache_conf` instead of `#apache`.'

        def_node_matcher :spec?, <<-PATTERN
          (block
            (send nil? :describe ...)
          ...)
        PATTERN

        def_node_matcher :apache?, <<~PATTERN
          (send nil? :apache ...)
        PATTERN

        def on_send(node)
          return unless apache?(node)

          add_offense(node, location: :selector)
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(node.loc.selector, preferred_replacement)
          end
        end

        private

        def inside_spec?(root)
          spec?(root)
        end

        def preferred_replacement
          cop_config.fetch('PreferredReplacement')
        end
      end
    end
  end
end
