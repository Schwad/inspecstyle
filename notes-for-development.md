# Notes for Dev

These are generic personal notes for useful documentation, approaches, and development strategies around constructing InSpecStyle. It's a bit hacked together like I will do for personal notes, but keeping together before this goes live to help others who might want to hack on InSpecStyle for the first time

- Toolsets for cop development: https://github.com/rubocop-hq/rubocop-ast/blob/master/docs/modules/ROOT/pages/node_pattern.adoc

- https://docs.rubocop.org/rubocop/development.html

- Advanced example custom cop: https://github.com/rubocop-hq/rubocop-rspec/blob/master/lib/rubocop/cop/rspec/not_to_not.rb

- https://www.rubyguides.com/2015/08/static-analysis-in-ruby/

- https://blog.arkency.com/using-ruby-parser-and-ast-tree-to-find-deprecated-syntax/

- attribute autocorrect (audit-cookbook)

- https://www.rubydoc.info/gems/rubocop-ast/RuboCop/AST/NodePattern

- hack on these specs locally and docs to learn https://github.com/rubocop-hq/rubocop-ast

<!-- (cookstyle)

- part of inspec (& check)
- part of cookstyle
- atom -->

```
ruby-parse -e '1'
(int 1)
```

Example usage for testing against example code:

`bundle exec rubocop violations.rb --only InSpecStyle/DeprecatedAttributes`

Processing via IRB for AST parsing:

```ruby
code = '!something.empty?'
source = RuboCop::ProcessedSource.new(code, RUBY_VERSION.to_f)
node = source.ast
node.type
node.children
node.source
NodePattern.new('(send ...)').match(node) # => true
```

- Implement CI

Correction docs at rubocop's: lib/rubocop/cop/corrector.rb

### Great Repos for cop examples
- rubocop-ast
- rubocop-rspec
- rubocop
