class Hash
  def hmap(&block)
    Hash[self.map {|k, v| block.call(k,v) }]
  end
end
