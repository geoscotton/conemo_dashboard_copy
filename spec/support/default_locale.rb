module DefaultLocale
  ActionView::TestCase::TestController.class_eval do
    undef_method :default_url_options
    def default_url_options(options={})
      { :locale => I18n.default_locale }
    end
  end

  ActionDispatch::Routing::RouteSet.class_eval do
    undef_method :default_url_options
    def default_url_options(options={})
      { :locale => I18n.default_locale }
    end
  end
end