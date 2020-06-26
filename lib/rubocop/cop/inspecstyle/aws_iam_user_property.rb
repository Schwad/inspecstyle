# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      # aws_iam_users resource properties `user|password|last_change|expiry_date|line` is deprecated in favor of `users|passwords|last_changes|expiry_dates|lines`
      #
      # @example EnforcedStyle: InSpecStyle (default)
      #   # Use users instead
      #
      #   # bad
      #   describe aws_iam_user('/etc/my-custom-place/aws_iam_user') do
      #     its('name') { should eq 'user' }
      #   end
      #
      #   # good
      #   describe aws_iam_user('/etc/my-custom-place/aws_iam_user') do
      #     its('username') { should eq 'user' }
      #   end
      #
      class AwsIamUserProperty < Cop
        include RangeHelp

        MSG = 'Use `:%<solution>s` instead of `:%<violation>s` as a property ' \
        'for the `aws_iam_user` resource. This property will be removed in InSpec 5'

        MAP = {
          user: "aws_user_struct",
          name: "username"
        }

        def_node_matcher :deprecated_aws_iam_users_property?, <<~PATTERN
          (block
            (send _ :its
              (str ${"name" "user"}) ...)
          ...)
        PATTERN

        def_node_matcher :spec?, <<-PATTERN
          (block
            (send nil? :describe ...)
          ...)
        PATTERN

        def_node_matcher :aws_iam_users_resource?, <<-PATTERN
          (block
            (send nil? :describe
              (send nil? :aws_iam_users ...)
            ...)
          ...)
        PATTERN

        def on_block(node)
          return unless inside_aws_iam_users_spec?(node)
          node.descendants.each do |descendant|
            deprecated_aws_iam_users_property?(descendant) do |violation|
              add_offense(
                descendant,
                location: offense_range(descendant),
                message: format(
                  MSG,
                  violation: violation,
                  solution: MAP[violation.to_sym]
                )
              )
            end
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            case node.children[0].children[-1].inspect
            when "s(:str, \"name\")"
              corrector.replace(offense_range(node), 'username')
            when "s(:str, \"user\")"
              corrector.replace(offense_range(node), 'aws_user_struct')
            else
              break
            end
          end
        end

        private

        def inside_aws_iam_users_spec?(root)
          spec?(root) && aws_iam_users_resource?(root)
        end

        def offense_range(node)
          source = node.children[0].children[-1].loc.expression
          range_between(source.begin_pos+1, source.end_pos-1)
        end
      end
    end
  end
end
