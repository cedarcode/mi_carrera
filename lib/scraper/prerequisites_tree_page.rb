require 'scraper/text_parser'

module Scraper
  module PrerequisitesTreePage
    extend self

    NODE_TYPE_MAPPING = {
      'y' => 'and', # debe tener todas
      'no' => 'not', # no debe tener
      'o' => 'or' # debe tener alguna
    }

    def prerequisite_tree(node)
      case node['data-nodetype']
      when *NODE_TYPE_MAPPING.keys then process_branch(node)
      when 'default', 'cag' then process_leaf(node)
      else raise "Unknown node_type: #{node['data-nodetype']}"
      end
    end

    private

    def process_branch(node)
      node.find('.ui-tree-toggler').click unless node[:class].include?('ui-treenode-expanded')
      children = node.sibling('.ui-treenode-children-container').all('.ui-treenode')
      operands = children.map { |child| prerequisite_tree(child) }
      { type: 'logical', logical_operator: NODE_TYPE_MAPPING[node['data-nodetype']], operands: }
    end

    def process_leaf(node)
      title = node.find('.negrita').text
      content = node.find('.ui-treenode-content').text

      TextParser.parse_leaf(title, content)
    end
  end
end
