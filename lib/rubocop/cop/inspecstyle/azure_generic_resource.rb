# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      # Do not use azure_generic_resource
      #
      # @example EnforcedStyle: InSpecStyle (default)
      #   # Description of the `inspecstyle` style.
      #
      #   # bad
      #   azure_generic_resource
      #
      #   # good
      #   azurerm_virtual_machine # use a specific resource pack resource
      #
      class AzureGenericResource < Cop
        MSG = 'Use a specific resource instead of `#azure_generic_resource`.'

        def_node_matcher :azure_generic_resource?, <<~PATTERN
          (block
            (send nil? :describe
              (send nil? :azure_generic_resource ...)
            ) ...)
        PATTERN

        def on_send(node)
          return unless azure_generic_resource?(node)

          add_offense(node)
        end
      end
    end
  end
end
