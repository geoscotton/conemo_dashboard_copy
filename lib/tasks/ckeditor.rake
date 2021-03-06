# frozen_string_literal: true
namespace :ckeditor do
  desc "Create nondigest versions of some ckeditor assets (e.g. moono skin png)"
  task :create_nondigest_assets do
    fingerprint = /\-[0-9a-f]{32}\./
    for file in Dir["public/assets/ckeditor/contents-*.css",
                    "public/assets/ckeditor/skins/moono/*.png",
                    "public/assets/ckeditor/lang/*.js",
                    "public/assets/ckeditor/skins/moono/*.css",
                    "public/assets/ckeditor/config-*.js",
                    "public/assets/ckeditor/plugins/forms/dialogs/*.js",
                    "public/assets/ckeditor/styles-*.js"]
      next unless file =~ fingerprint
      nondigest = file.sub fingerprint, "." # contents-0d8ffa186a00f5063461bc0ba0d96087.css => contents.css
      FileUtils.cp file, nondigest, verbose: true
    end
  end
end

# auto run ckeditor:create_nondigest_assets after assets:precompile
Rake::Task["assets:precompile"].enhance do
  Rake::Task["ckeditor:create_nondigest_assets"].invoke
end
