module ActiveStorage::WistiaBlob
  def analyzer_class
    # We can't analyze Wistia videos since they're not stored locally.
    return ActiveStorage::Analyzer::NullAnalyzer if service_name == "wistia"

    super
  end
end
