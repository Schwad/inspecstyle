# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      # @example EnforcedStyle: InSpecStyle (default)
      #   # script has been deprecated as a resource. Use powershell instead
      #
      class ScriptResource < Cop
        MSG = 'Use `powershell` instead of `script`. '\
              'This resource will be removed in InSpec 5.'

        def_node_matcher :spec?, <<-PATTERN
          (block
            (send nil? :describe ...)
          ...)
        PATTERN

        def_node_matcher :script?, <<~PATTERN
          (send nil? :script ...)
        PATTERN

        def on_send(node)
          return unless script?(node)

          add_offense(node, location: :selector)
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(node.loc.selector, preferred_replacement)
          end
        end

        private

        def inside_file_spec?(root)
          spec?(root)
        end

        def preferred_replacement
          cop_config.fetch('PreferredReplacement')
        end
      end
    end
  end
end
