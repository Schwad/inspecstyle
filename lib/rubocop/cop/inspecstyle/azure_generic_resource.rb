# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      # Do not use azure_generic_resource
      #
      # @example EnforcedStyle: InSpecStyle (default)
      #   # azure_generic_resource has been deprecated
      #   # 'https://github.com/inspec/inspec/issues/3131'
      #
      #   # bad
      #   azure_generic_resource
      #
      #   # good
      #   azurerm_virtual_machine # use a specific resource pack resource
      #
      class AzureGenericResource < Cop
        MSG = 'Use a specific resource instead of `#azure_generic_resource`. '\
              'This resource will be removed in InSpec 5.'

        def_node_matcher :azure_generic_resource?, <<~PATTERN
          (send nil? :azure_generic_resource ...)
        PATTERN

        def on_send(node)
          return unless azure_generic_resource?(node)

          add_offense(node, location: node.loc.selector)
        end
      end
    end
  end
end
