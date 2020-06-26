# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      # @example EnforcedStyle: InSpecStyle (default)
      #   `list` property for `processes` resource is deprecated for `entries` and will be removed in InSpec5
      #
      #   # bad
      #   describe processes('my_processes.txt') do
      #     its('list') { should eq 12345 }
      #   end
      #
      #   # good
      #   describe processes('my_processes.txt') do
      #     its('entries') { should eq 12345 }
      #   end
      #
      class ProcessesList < Cop
        include RangeHelp

        MSG = '`list` property for `processes` resource is deprecated for `entries` and will be removed in InSpec5'

        def_node_matcher :processes_resource_list?, <<~PATTERN
          (block
            (send _ :its
              (str "list") ...)
          ...)
        PATTERN

        def_node_matcher :spec?, <<-PATTERN
          (block
            (send nil? :describe ...)
          ...)
        PATTERN

        def_node_matcher :processes_resource?, <<-PATTERN
          (block
            (send nil? :describe
              (send nil? :processes ...)
            ...)
          ...)
        PATTERN


        def on_block(node)
          return unless inside_processes_spec?(node)
          node.descendants.each do |descendant|
            next unless processes_resource_list?(descendant)
            add_offense(descendant, location: offense_range(descendant))
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(offense_range(node), preferred_replacement)
          end
        end

        private

        def inside_processes_spec?(root)
          spec?(root) && processes_resource?(root)
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
