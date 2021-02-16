def source_paths
  Array(super) +
    [File.join(File.expand_path(File.dirname(__FILE__)))]
end

def template_root
  File.join(File.expand_path(File.dirname(__FILE__)))
end

run "yarn add bootstrap jquery popper.js"

# config/webpack/environment.js
insert_into_file "config/webpack/environment.js", after: /@rails\/webpacker.*\n/ do
  <<-WEBPACKJS

const webpack = require("webpack")
environment.plugins.append("Provide", new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
}))
  WEBPACKJS
end

# app/javascript/packs/application.js
insert_into_file "app/javascript/packs/application.js", before: /\/\/ Uncomment to copy all static/ do
  <<-PACKAPPJS
import 'bootstrap';
import '../stylesheets/application';
document.addEventListener("turbolinks:load", () => {
    $('[data-toggle="tooltip"]').tooltip()
});
  PACKAPPJS
end

# config/webpacker.yml
gsub_file "config/webpacker.yml", /resolved_paths: \[\]/, "resolved_paths: ['app/assets']"

# app/javascript/stylesheets
run "mkdir app/javascript/stylesheets"
run "touch app/javascript/stylesheets/application.scss"
append_to_file 'app/javascript/stylesheets/application.scss' do
  "@import 'bootstrap';\n"
end
