class IndicesImport
  def self.run(date = Date.yesterday)
    [
        CoMagick::Import,
        Seopult::Import,
        Direct::Import,
        Adwords::Import
    ].each do |import_class|
        import_class.new(date).run!
    end
  end
end