module Colibri
  module ProductsHelper
    # returns the formatted price for the specified variant as a full price or a difference depending on configuration
    def variant_price(variant)
      if Colibri::Config[:show_variant_full_price]
        variant_full_price(variant)
      else
        variant_price_diff(variant)
      end
    end

    # returns the formatted price for the specified variant as a difference from product price
    def variant_price_diff(variant)
      diff = variant.amount_in(current_currency) - variant.product.amount_in(current_currency)
      return nil if diff == 0
      amount = Colibri::Money.new(diff.abs, { currency: current_currency }).to_html
      if diff > 0
        "(#{Colibri.t(:add)}: #{amount})".html_safe
      else
        "(#{Colibri.t(:subtract)}: #{amount})".html_safe
      end
    end

    # returns the formatted full price for the variant, if at least one variant price differs from product price
    def variant_full_price(variant)
      product = variant.product
      unless product.variants.active(current_currency).all? { |v| v.price == product.price }
        Colibri::Money.new(variant.price, { currency: current_currency }).to_html
      end
    end

    # converts line breaks in product description into <p> tags (for html display purposes)
    def product_description(product)
      if Colibri::Config[:show_raw_product_description]
        raw(product.description)
      else
        raw(product.description.gsub(/(.*?)\r?\n\r?\n/m, '<p>\1</p>'))
      end
    end

    def line_item_description(variant)
      ActiveSupport::Deprecation.warn "line_item_description(variant) is deprecated and may be removed from future releases, use line_item_description_text(line_item.description) instead.", caller

      line_item_description_text(variant.product.description)
    end

    def line_item_description_text description_text
      if description_text.present?
        truncate(strip_tags(description_text.gsub('&nbsp;', ' ')), length: 100)
      else
        Colibri.t(:product_has_no_description)
      end
    end

    def cache_key_for_products
      count = @products.count
      max_updated_at = (@products.maximum(:updated_at) || Date.today).to_s(:number)
      "#{current_currency}/colibri/products/all-#{params[:page]}-#{max_updated_at}-#{count}"
    end
  end
end
