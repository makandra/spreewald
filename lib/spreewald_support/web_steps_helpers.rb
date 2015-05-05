module WebStepsHelpers

  def assert_visible(options)
    visibility_test(options.merge(:expectation => :visible))
  end

  def assert_hidden(options)
    visibility_test(options.merge(:expectation => :hidden))
  end

  private

  def visibility_test(options)
    case Capybara::current_driver
    when :selenium, :webkit, :poltergeist
      detect_visibility_with_js(options)
    else
      detect_visibility_with_capybara(options)
    end
  end

  def detect_visibility_with_js(options)
    patiently do

      selector_javascript = if options.has_key?(:selector)
        options[:selector].to_json
      else
        "':contains(' + " + options[:text].to_json + " + ')'"
      end

      visibility_detecting_javascript = %[
        return (function() {
          var selector = #{selector_javascript};
          var jqueryLoaded = (typeof jQuery != 'undefined');

          function findCandidates() {
            if (jqueryLoaded) {
              return $(selector);
            } else {
              return $$(selector);
            }
          }

          function isExactCandidate(candidate) {
            if (jqueryLoaded) {
              return $(candidate).find(selector).length == 0;
            } else {
              return candidate.select(selector).length == 0;
            }
          }

          function elementVisible(element) {
            if (jqueryLoaded) {
              return $(element).is(':visible');
            } else {
              return element.offsetWidth > 0 && element.offsetHeight > 0;
            }
          }

          var candidates = findCandidates();

          if (candidates.length == 0) {
             throw("Selector not found in page: " + selector);
           }

          for (var i = 0; i < candidates.length; i++) {
            var candidate = candidates[i];
            if (isExactCandidate(candidate) && elementVisible(candidate)) {
              return true;
            }
          }
          return false;

        })();
      ]

      visibility_detecting_javascript.gsub!(/\n/, ' ')
      if options[:expectation] == :visible
        page.execute_script(visibility_detecting_javascript).should == true
      else
        page.execute_script(visibility_detecting_javascript).should == false
      end
    end
  end

  def detect_visibility_with_capybara(options)
    begin
      old_ignore_hidden_elements = Capybara.ignore_hidden_elements
      Capybara.ignore_hidden_elements = false
      if options.has_key?(:selector)
        page.should have_css(options[:selector])
        have_hidden_tag = have_css(".hidden #{options[:selector]}, .invisible #{selector_or_text}, [style~=\"display: none\"] #{options[:selector]}")
        if options[:expectation] == :hidden
          page.should have_hidden_tag
        else
          page.should_not have_hidden_tag
        end
      else
        page.should have_css('*', :text => options[:text])
        have_hidden_text = have_css('.hidden, .invisible, [style~="display: none"]', :text => options[:text])
        if options[:expectation] == :hidden
          page.should have_hidden_text
        else
          page.should_not have_hidden_text
        end
      end
    ensure
      Capybara.ignore_hidden_elements = old_ignore_hidden_elements
    end
  end

end

World(WebStepsHelpers)
