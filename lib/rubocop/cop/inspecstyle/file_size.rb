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

        MSG = '`size` property for `file` resource is deprecated for `size_kb` and will be removed in InSpec5'

        def_node_matcher :file_resource_size_property?, <<~PATTERN
          (block
            (send _ :describe
              (send _ :file ...) ...)
            (args ...)
            (begin
              (block
                (send _ :its
                  (send _ :size) ...) ...) ...) ...)
        PATTERN

        def on_block(node)
          return unless file_resource_size_property?(node)

          add_offense(node)
        end
      end
    end
  end
end
