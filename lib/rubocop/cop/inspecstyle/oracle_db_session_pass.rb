# frozen_string_literal: true

module RuboCop
  module Cop
    module InSpecStyle
      #
      # @example EnforcedStyle: InSpecStyle (default)
      #   # Description of the `bar` style.
      #
      #   # bad
      #   sql = oracledb_session(user: 'my_user', pass: 'password')
      #
      #   # good
      #   sql = oracledb_session(user: 'my_user', password: 'password')
      class OracleDbSessionPass < Cop
        include MatchRange
        MSG = 'Use `:password` instead of `:pass`. This will be removed in '\
              'InSpec 5'

        def_node_matcher :oracledb_session_pass?, <<~PATTERN
          (send _ :oracledb_session
            (hash
              ...
              (pair
                (sym $:pass)
                ...)))
        PATTERN

        # Getting location was a bit tricky on this one, looking at docs perhaps
        # convention does allow highlighting an entire line.
        def on_send(node)
          return unless result = oracledb_session_pass?(node)
          add_offense(node, message: MSG)
        end
      end
    end
  end
end
