include Java
swing_classes = %w(JFrame JButton JList JSplitPane
JTabbedPane JTextPane JScrollPane JEditorPane
DefaultListModel ListSelectionModel BoxLayout
JScrollPane JTree tree.TreeModel
text.html.HTMLEditorKit tree.DefaultMutableTreeNode tree.TreeNode)
swing_classes.each do |c|
  java_import "javax.swing.#{c}"
end

class MyTreeNode < javax.swing.tree.DefaultMutableTreeNode

  def initialize(node, name, path)
    super node
    @name = name
    @path = path
    setUserObject(name)
  end

  def name
    @name
  end

  def path
    @path
  end

end
