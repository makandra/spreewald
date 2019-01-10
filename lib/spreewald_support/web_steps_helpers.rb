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

      if selector = options[:selector]
        visible = page.execute_script(<<-JAVASCRIPT)
          function isVisible(element) {
             return !!(element.offsetWidth || element.offsetHeight || element.getClientRects().length);
          }
          
          var element = document.querySelector(#{selector.to_json});

          if (!element) {
            throw new Error("No element found for selector: "+ #{selector.to_json});
          }

          return isVisible(element);
        JAVASCRIPT
      elsif text = options[:text]
        visible = page.execute_script(<<-JAVASCRIPT)
          // This entire code block can be replaced with this single line
          // when we drop support for ancient Firefoxes (< 45):
          //
          //     return document.body.innerText.indexOf(#{text.to_json}) >= 0

          function isVisible(element) {
             return !!(element.offsetWidth || element.offsetHeight || element.getClientRects().length);
          }

          var candidates = document.querySelectorAll('*');
          candidates = Array.prototype.slice.call(candidates);

          candidates = candidates.filter(function(candidate) {
            var text = candidate.textContent;
            return text && text.indexOf(#{text.to_json}) >= 0;
          });

          candidates = candidates.filter(function(candidate) {
            return !candidates.some(function(other) {
              return candidate !== other && candidate.contains(other);
            });
          });
          
          return candidates.some(isVisible);
        JAVASCRIPT
      else
        raise "Must pass either :selector or :text option"
      end

      if options[:expectation] == :visible
        visible.should eq(true)
      else
        visible.should eq(false)
      end
    end
  end

  def detect_visibility_with_capybara(options)
    begin
      old_ignore_hidden_elements = Capybara.ignore_hidden_elements
      Capybara.ignore_hidden_elements = false

      if options.has_key?(:selector)
        selector = options[:selector].strip
        page.should have_css options[:selector]

        have_hidden_tag = have_css %(.hidden #{selector}, .invisible #{selector}, [style~="display: none"] #{selector})

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
