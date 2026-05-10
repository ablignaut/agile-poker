module SizingDefinitions
  PATH = Rails.root.join("config", "sizing_definitions.yml")

  CATEGORIES = %i[complexity amount_of_work unknown_risk].freeze

  class << self
    def all
      @all ||= load!
    end

    def for(category, level)
      levels(category)[level.to_sym]
    end

    def levels(category)
      all.fetch(category.to_sym, {})
    end

    def reload!
      @all = nil
      all
    end

    private

    def load!
      YAML.safe_load_file(PATH).deep_symbolize_keys
    end
  end
end
