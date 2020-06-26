# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      # @example EnforcedStyle: InSpecStyle (default)
      #   `proto` property for `host` resource is deprecated for `protocol` and will be removed in InSpec5
      #
      #   # bad
      #   describe host('my_host.txt') do
      #     its('proto') { should eq 12345 }
      #   end
      #
      #   # good
      #   describe host('my_host.txt') do
      #     its('protocol') { should eq 12345 }
      #   end
      #
      class HostProto < Cop
        include RangeHelp

        MSG = '`proto` property for `host` resource is deprecated for `protocol` and will be removed in InSpec5'

        def_node_matcher :host_resource_proto_property?, <<~PATTERN
          (block
            (send _ :its
              (str "proto") ...)
          ...)
        PATTERN

        def_node_matcher :host_resource?, <<-PATTERN
          (block
            (send nil? :describe
              (send nil? :host ...)
            ...)
          ...)
        PATTERN


        def on_block(node)
          return unless inside_resource_spec?(node)
          node.descendants.each do |descendant|
            next unless host_resource_proto_property?(descendant)
            add_offense(descendant, location: offense_range(descendant))
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(offense_range(node), preferred_replacement)
          end
        end

        private

        def inside_resource_spec?(root)
          host_resource?(root)
        end

        def preferred_replacement
          cop_config.fetch('PreferredReplacement')
        end

        def offense_range(node)
          source = node.children[0].children[-1].loc.expression
          range_between(source.begin_pos+1, source.end_pos-1)
        end
      end
    end
  end
end
