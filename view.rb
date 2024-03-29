include Java
swing_classes = %w(JFrame JButton JList JSplitPane
JTabbedPane JTextPane JScrollPane JEditorPane
DefaultListModel ListSelectionModel BoxLayout
JScrollPane JTree tree.TreeModel
text.html.HTMLEditorKit tree.DefaultMutableTreeNode tree.TreeNode)
swing_classes.each do |c|
  java_import "javax.swing.#{c}"
end

import java.lang.System
import java.awt.BorderLayout
import java.awt.Color
import javax.swing.JFrame
import javax.swing.JTree
import javax.swing.JButton
import javax.swing.JPanel
import javax.swing.JToolBar
import javax.swing.JFileChooser
import javax.swing.JTextArea
import javax.swing.JTextPane
import javax.swing.JScrollPane
import javax.swing.BorderFactory
import javax.swing.filechooser::FileNameExtensionFilter
require_relative 'filer'
require_relative 'my_tree_node'


class View < JFrame
  
    def initialize
        super "TextDog"
        @filer = Filer.new        
        self.initUI
    end
      
    def initUI
        @panel = JPanel.new
        @panel.setLayout BorderLayout.new
        toolbar = JToolBar.new
        newb = JButton.new "New"
        openb = JButton.new "Open"
        saveb = JButton.new "Save"
        closeb = JButton.new "Close"
        exitb = JButton.new "Exit"
        openb.addActionListener do |e|
          chooseFile = JFileChooser.new
          ret = chooseFile.showDialog @panel, "Choose file"

          if ret == JFileChooser::APPROVE_OPTION
            file = chooseFile.getSelectedFile
            text = self.readFile file
            @area.setText text.to_s.force_encoding('utf-8').encode
          end
        end

        saveb.addActionListener do |e|
          if @current_file
            @filer.save(@current_file, @area)
          else
            chooseFile = JFileChooser.new
            ret = chooseFile.showDialog @panel, "Save As"

            if ret == JFileChooser::APPROVE_OPTION
                file = chooseFile.getSelectedFile
                @filer.save_as(file, @area.getText)
            end
          end
        end

        newb.addActionListener do |e|
          @area.setText ''
          @current_file = nil
        end

        closeb.addActionListener do |e|
          @area.setText ''
          @current_file = nil
        end

        exitb.addActionListener do |e|
          System.exit 0
        end
        root = "/Users/dan/Desktop"
        n = 0
        dir = Dir.new(root)
        dir_node = DefaultMutableTreeNode.new(dir)
        tree = JTree.new(dir_node)
        tree.addTreeSelectionListener do |e|
          filename = tree.getLastSelectedPathComponent.getUserObject
          p filename
          p f = tree.getLastSelectedPathComponent.getPath
          p @current_file = tree.getLastSelectedPathComponent.path
          @area.setText @filer.open_by_path(tree.getLastSelectedPathComponent.path)
        end
        scrollPane = JScrollPane.new(tree)
        create_tree(dir, dir_node, root) 
        @panel.add scrollPane, BorderLayout::EAST

        toolbar.add newb
        toolbar.add openb
        toolbar.add saveb
        toolbar.add closeb
        toolbar.add exitb
        @area = JTextArea.new
        @area.setBorder BorderFactory.createEmptyBorder 10, 10, 10, 10
        @area.setTabSize(1)
        pane = JScrollPane.new
        pane.getViewport.add @area

        @panel.setBorder BorderFactory.createEmptyBorder 10, 10, 10, 10
        @panel.add pane
        self.add @panel

        self.add toolbar, BorderLayout::NORTH
        
        self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
        self.setSize 750, 700
        self.setLocationRelativeTo nil
        self.setVisible true
    end
    
    def readFile file
      text = @filer.open file        
      @current_file = @filer.filename
      return text
    end

    def create_tree(dir, dir_node, path)
      dir.each { |f|
        next if f == "." or f == ".." or f[0] == "." or f.include? '.result'
        p = File.join(path, f)
        file_dir = File.directory?(p)
        if file_dir
          dir = Dir.new(p)
          n = MyTreeNode.new(n, f, p)
          dir_node.add(n)
          create_tree(dir, n, p)
        else
          #node = DefaultMutableTreeNode.new(f)
          n = MyTreeNode.new(f, f, p)
          dir_node.add(n)
        end
      }
    end

end

View.new
