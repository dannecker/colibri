Colibri::Sample.load_sample("products")
Colibri::Sample.load_sample("variants")

products = {}
products[:ror_baseball_jersey] = Colibri::Product.find_by_name!("Ruby on Rails Baseball Jersey") 
products[:ror_tote] = Colibri::Product.find_by_name!("Ruby on Rails Tote")
products[:ror_bag] = Colibri::Product.find_by_name!("Ruby on Rails Bag")
products[:ror_jr_spaghetti] = Colibri::Product.find_by_name!("Ruby on Rails Jr. Spaghetti")
products[:ror_mug] = Colibri::Product.find_by_name!("Ruby on Rails Mug")
products[:ror_ringer] = Colibri::Product.find_by_name!("Ruby on Rails Ringer T-Shirt")
products[:ror_stein] = Colibri::Product.find_by_name!("Ruby on Rails Stein")
products[:colibri_baseball_jersey] = Colibri::Product.find_by_name!("Colibri Baseball Jersey")
products[:colibri_stein] = Colibri::Product.find_by_name!("Colibri Stein")
products[:colibri_jr_spaghetti] = Colibri::Product.find_by_name!("Colibri Jr. Spaghetti")
products[:colibri_mug] = Colibri::Product.find_by_name!("Colibri Mug")
products[:colibri_ringer] = Colibri::Product.find_by_name!("Colibri Ringer T-Shirt")
products[:colibri_tote] = Colibri::Product.find_by_name!("Colibri Tote")
products[:colibri_bag] = Colibri::Product.find_by_name!("Colibri Bag")
products[:ruby_baseball_jersey] = Colibri::Product.find_by_name!("Ruby Baseball Jersey")
products[:apache_baseball_jersey] = Colibri::Product.find_by_name!("Apache Baseball Jersey")


def image(name, type="jpeg")
  images_path = Pathname.new(File.dirname(__FILE__)) + "images"
  path = images_path + "#{name}.#{type}"
  return false if !File.exist?(path)
  File.open(path)
end

images = {
  products[:ror_tote].master => [
    {
      :attachment => image("ror_tote")
    },
    {
      :attachment => image("ror_tote_back") 
    }
  ],
  products[:ror_bag].master => [
    {
      :attachment => image("ror_bag")
    }
  ],
  products[:ror_baseball_jersey].master => [
    {
      :attachment => image("ror_baseball")
    },
    {
      :attachment => image("ror_baseball_back")
    }
  ],
  products[:ror_jr_spaghetti].master => [
    {
      :attachment => image("ror_jr_spaghetti")
    }
  ],
  products[:ror_mug].master => [
    {
      :attachment => image("ror_mug")
    },
    {
      :attachment => image("ror_mug_back")
    }
  ],
  products[:ror_ringer].master => [
    {
      :attachment => image("ror_ringer")
    },
    {
      :attachment => image("ror_ringer_back")
    }
  ],
  products[:ror_stein].master => [
    {
      :attachment => image("ror_stein")
    },
    {
      :attachment => image("ror_stein_back")
    }
  ],
  products[:apache_baseball_jersey].master => [
    {
      :attachment => image("apache_baseball", "png")
    },
  ],
  products[:ruby_baseball_jersey].master => [
    {
      :attachment => image("ruby_baseball", "png")
    },
  ],
  products[:colibri_bag].master => [
    {
      :attachment => image("colibri_bag")
    },
  ],
  products[:colibri_tote].master => [
    {
      :attachment => image("colibri_tote_front")
    },
    {
      :attachment => image("colibri_tote_back") 
    }
  ],
  products[:colibri_ringer].master => [
    {
      :attachment => image("colibri_ringer_t")
    },
    {
      :attachment => image("colibri_ringer_t_back") 
    }
  ],
  products[:colibri_jr_spaghetti].master => [
    {
      :attachment => image("colibri_spaghetti")
    }
  ],
  products[:colibri_baseball_jersey].master => [
    {
      :attachment => image("colibri_jersey")
    },
    {
      :attachment => image("colibri_jersey_back") 
    }
  ],
  products[:colibri_stein].master => [
    {
      :attachment => image("colibri_stein")
    },
    {
      :attachment => image("colibri_stein_back") 
    }
  ],
  products[:colibri_mug].master => [
    {
      :attachment => image("colibri_mug")
    },
    {
      :attachment => image("colibri_mug_back") 
    }
  ],
}

products[:ror_baseball_jersey].variants.each do |variant|
  color = variant.option_value("tshirt-color").downcase
  main_image = image("ror_baseball_jersey_#{color}", "png")
  variant.images.create!(:attachment => main_image)
  back_image = image("ror_baseball_jersey_back_#{color}", "png")
  if back_image
    variant.images.create!(:attachment => back_image)
  end
end

images.each do |variant, attachments|
  puts "Loading images for #{variant.product.name}"
  attachments.each do |attachment|
    variant.images.create!(attachment)
  end
end

