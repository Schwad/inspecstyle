# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      # @example EnforcedStyle: InSpecStyle (default)
      #   # windows_registry_key has been deprecated as a resource. Use registry_key instead
      #
      class WindowsRegistryKey < Cop
        MSG = 'Use `registry_key` instead of `windows_registry_key`. '\
              'This resource will be removed in InSpec 5.'

        def_node_matcher :windows_registry_key?, <<~PATTERN
          (send _ :windows_registry_key ...)
        PATTERN

        def on_send(node)
          return unless windows_registry_key?(node)
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
