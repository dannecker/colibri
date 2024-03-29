require 'colibri/testing_support/common_rake'

desc "Generates a dummy app for testing an extension"
namespace :extension do
  task :test_colibri, [:user_class] do |t, args|
    Colibri::DummyGeneratorHelper.inject_extension_requirements = true
    Rake::Task['common:test_colibri'].invoke
  end
end

