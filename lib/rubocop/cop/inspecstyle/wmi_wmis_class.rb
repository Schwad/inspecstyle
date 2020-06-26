# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      # @example EnforcedStyle: InSpecStyle (default)
      #   # wmi_wmis_class has been deprecated as a resource. Use iis_site instead
      #
      class WmiWmisClass < Cop
        MSG = 'Use `iis_site` instead of `wmi_wmis_class`. '\
              'This resource will be removed in InSpec 5.'

        def_node_matcher :wmi_wmis_class?, <<~PATTERN
          (send _ :wmi
            (str "wmisclass") ...)
        PATTERN

        def on_send(node)
          return unless wmi_wmis_class?(node)
          add_offense(node)
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(node.source_range, preferred_replacement)
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
