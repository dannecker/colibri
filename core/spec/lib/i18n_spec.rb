require 'rspec/expectations'
require 'colibri/i18n'
require 'colibri/testing_support/i18n'

describe "i18n" do
  before do
    I18n.backend.store_translations(:en,
    {
      :colibri => {
        :foo => "bar",
        :bar => {
          :foo => "bar within bar scope",
          :invalid => nil,
          :legacy_translation => "back in the day..."
        },
        :invalid => nil,
        :legacy_translation => "back in the day..."
      }
    })
  end

  it "translates within the colibri scope" do
    Colibri.normal_t(:foo).should eql("bar")
    Colibri.translate(:foo).should eql("bar")
  end

  it "translates within the colibri scope using a path" do
    Colibri.stub(:virtual_path).and_return('bar')

    Colibri.normal_t('.legacy_translation').should eql("back in the day...")
    Colibri.translate('.legacy_translation').should eql("back in the day...")
  end

  it "raise error without any context when using a path" do
    expect {
      Colibri.normal_t('.legacy_translation')
    }.to raise_error

    expect {
      Colibri.translate('.legacy_translation')
    }.to raise_error
  end

  it "prepends a string scope" do
    Colibri.normal_t(:foo, :scope => "bar").should eql("bar within bar scope")
  end

  it "prepends to an array scope" do
    Colibri.normal_t(:foo, :scope => ["bar"]).should eql("bar within bar scope")
  end

  it "returns two translations" do
    Colibri.normal_t([:foo, 'bar.foo']).should eql(["bar", "bar within bar scope"])
  end

  it "returns reasonable string for missing translations" do
    Colibri.t(:missing_entry).should include("<span")
  end

  context "missed + unused translations" do
    def key_with_locale(key)
      "#{key} (#{I18n.locale})"
    end

    before do
      Colibri.used_translations = []
    end

    context "missed translations" do
      def assert_missing_translation(key)
        key = key_with_locale(key)
        message = Colibri.missing_translation_messages.detect { |m| m == key }
        message.should_not(be_nil, "expected '#{key}' to be missing, but it wasn't.")
      end

      it "logs missing translations" do
        Colibri.t(:missing, :scope => [:else, :where])
        Colibri.check_missing_translations
        assert_missing_translation("else")
        assert_missing_translation("else.where")
        assert_missing_translation("else.where.missing")
      end

      it "does not log present translations" do
        Colibri.t(:foo)
        Colibri.check_missing_translations
        Colibri.missing_translation_messages.should be_empty
      end

      it "does not break when asked for multiple translations" do
        Colibri.t [:foo, 'bar.foo']
        Colibri.check_missing_translations
        Colibri.missing_translation_messages.should be_empty
      end
    end

    context "unused translations" do
      def assert_unused_translation(key)
        key = key_with_locale(key)
        message = Colibri.unused_translation_messages.detect { |m| m == key }
        message.should_not(be_nil, "expected '#{key}' to be unused, but it was used.")
      end

      def assert_used_translation(key)
        key = key_with_locale(key)
        message = Colibri.unused_translation_messages.detect { |m| m == key }
        message.should(be_nil, "expected '#{key}' to be used, but it wasn't.")
      end

      it "logs translations that aren't used" do
        Colibri.check_unused_translations
        assert_unused_translation("bar.legacy_translation")
        assert_unused_translation("legacy_translation")
      end

      it "does not log used translations" do
        Colibri.t(:foo)
        Colibri.check_unused_translations
        assert_used_translation("foo")
      end
    end
  end
end
