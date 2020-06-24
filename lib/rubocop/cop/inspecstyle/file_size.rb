# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      # @example EnforcedStyle: InSpecStyle (default)
      #   `size` property for `file` resource is deprecated for `size_kb` and will be removed in InSpec5
      #
      #   # bad
      #   describe file('my_file.txt') do
      #     its('size') { should eq 12345 }
      #   end
      #
      #   # good
      #   describe file('my_file.txt') do
      #     its('size_kb') { should eq 12345 }
      #   end
      #
      class FileSize < Cop
        include RangeHelp

        MSG = '`size` property for `file` resource is deprecated for `size_kb` and will be removed in InSpec5'

        def_node_matcher :file_resource_size_property?, <<~PATTERN
          (block
            (send _ :its
              (str "size") ...)
          ...)
        PATTERN

        def_node_matcher :spec?, <<-PATTERN
          (block
            (send nil? :describe ...)
          ...)
        PATTERN

        def_node_matcher :file_resource?, <<-PATTERN
          (block
            (send nil? :describe
              (send nil? :file ...)
            ...)
          ...)
        PATTERN


        def on_block(node)
          return unless inside_file_spec?(node)
          node.descendants.each do |descendant|
            next unless file_resource_size_property?(descendant)
            add_offense(descendant, location: offense_range(descendant))
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(offense_range(node), preferred_replacement)
          end
        end

        private

        def inside_file_spec?(root)
          spec?(root) && file_resource?(root)
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
