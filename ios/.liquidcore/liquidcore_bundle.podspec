Pod::Spec.new do |s|
  s.name = 'liquidcore_bundle'
  s.version = '1.0.0'
  s.summary = 'Bundled JS files for LiquidCore'
  s.description = 'A pod containing the files generated from the JS bundler'
  s.author = ''
  s.homepage = 'http'
  s.source = { :git => "" }
  s.resource_bundles = {
   'LiquidCore' => [
      'ios_bundle/*.js'
   ]
 }
 s.script_phase = { :name => 'Bundle JavaScript Files', :script => '(cd ..; node node_modules/liquidcore/lib/cli.js bundle --platform=ios)' }
end