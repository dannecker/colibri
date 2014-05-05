module ColibriCmd
  class Version < Thor::Group
    include Thor::Actions

		desc 'display colibri_cmd version'
		
		def cmd_version
			puts Gem.loaded_specs['colibri_cmd'].version
		end

  end
end
