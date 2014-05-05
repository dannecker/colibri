Colibri::Sample.load_sample("products")

size = Colibri::OptionType.find_by_presentation!("Size")
color = Colibri::OptionType.find_by_presentation!("Color")

ror_baseball_jersey = Colibri::Product.find_by_name!("Ruby on Rails Baseball Jersey")
ror_baseball_jersey.option_types = [size, color]
ror_baseball_jersey.save!

colibri_baseball_jersey = Colibri::Product.find_by_name!("Colibri Baseball Jersey")
colibri_baseball_jersey.option_types = [size, color]
colibri_baseball_jersey.save!
