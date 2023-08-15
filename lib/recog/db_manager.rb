# frozen_string_literal: true

module Recog
  class DBManager
    require 'nokogiri'
    require 'recog/db'

    attr_accessor :path, :databases

    DefaultDatabasePath = File.expand_path(File.join(File.expand_path(__dir__), ['..', '..', 'recog', 'xml']))

    def initialize(path = DefaultDatabasePath)
      self.path = path
      reload
    end

    def load_databases
      if File.directory?(path)
        Dir["#{path}/*.xml"].each do |dbxml|
          databases << DB.new(dbxml)
        end
      else
        databases << DB.new(path)
      end
    end

    def reload
      self.databases = []
      load_databases
    end
  end
end
