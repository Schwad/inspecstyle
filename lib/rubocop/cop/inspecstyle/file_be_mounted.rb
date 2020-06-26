# frozen_string_literal: true

# NOTE TO SELF - this one works BUT not if other its statements are defined. Needs
# to work in any arrangement. This is a powerful one to crack as this pattern
# will be used in a LOT of other cops.

module RuboCop
  module Cop
    module InSpecStyle
      # file resource deprecates matchers `be_mounted.with` and `be_mounted.only_with` in favor of the mount resource
      #

      class FileBeMounted < Cop
        MSG = 'Use the `:mount` resource instead of `be_mounted.%<violation>s` ' \
        "\nThis matcher will be removed in InSpec 5"

        def_node_matcher :deprecated_file_matcher?, <<~PATTERN
          (send
            (send _ :be_mounted ...) ${:with :only_with}
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
            deprecated_file_matcher?(descendant) do |violation|
              add_offense(
                descendant,
                location: offense_range(descendant),
                message: format(
                  MSG,
                  violation: violation
                )
              )
            end
          end
        end

        private

        def inside_file_spec?(root)
          spec?(root) && file_resource?(root)
        end

        def offense_range(node)
          node.loc.selector
        end
      end
    end
  end
end
