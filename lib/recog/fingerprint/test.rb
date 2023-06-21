# frozen_string_literal: true

class Recog::Fingerprint::Test
  attr_accessor :content, :attributes

  def initialize(content, attributes = [])
    @attributes = attributes

    @content = if @attributes['_encoding'] && @attributes['_encoding'] == 'base64'
                 content.to_s.unpack1('m*')
               else
                 content
               end
  end

  def to_s
    content
  end
end
