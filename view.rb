include Java

import java.lang.System
import java.awt.BorderLayout
import java.awt.Color
import javax.swing.JFrame
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

class View < JFrame
  
    def initialize
        super "FileChooser"
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
          p "SAVE-------->"
          p @area.getText
          p @current_file
          if @current_file
            @filer.save(@current_file, @area)
          else
            p 'PROMPT FOR SAVE AS'
          end
        end

        newb.addActionListener do |e|
          @area.setText ''
          @current_file = nil
        end

        exitb.addActionListener do |e|
          System.exit 0
        end

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
end

View.new
