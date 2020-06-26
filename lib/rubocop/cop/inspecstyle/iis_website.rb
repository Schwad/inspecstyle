# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      # @example EnforcedStyle: InSpecStyle (default)
      #   # iis_website has been deprecated as a resource. Use iis_site instead
      #
      class IisWebsite < Cop
        MSG = 'Use `iis_site` instead of `iis_website`. '\
              'This resource will be removed in InSpec 5.'

        def_node_matcher :iis_website?, <<~PATTERN
          (send _ :iis_website ...)
        PATTERN

        def on_send(node)
          return unless iis_website?(node)
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
