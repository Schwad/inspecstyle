# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      # @example EnforcedStyle: InSpecStyle (default)
      #   # linux_kernel_parameter has been deprecated as a resource. Use kernel_parameter instead
      #
      class LinuxKernelParameter < Cop
        MSG = 'Use `kernel_parameter` instead of `linux_kernel_parameter`. '\
              'This resource will be removed in InSpec 5.'

        def_node_matcher :linux_kernel_parameter?, <<~PATTERN
          (send nil? :linux_kernel_parameter ...)
        PATTERN

        def on_send(node)
          return unless linux_kernel_parameter?(node)

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
