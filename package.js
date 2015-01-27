Package.describe({
  name: 'ccorcos:transitioner',
  summary: 'Page transitions integrated with Iron Router.',
  version: '0.0.1',
  git: 'https://github.com/ccorcos/'
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1');

  api.use([
    'coffeescript',
    'velocityjs:velocityjs',
    'iron:router',
    'templating',
    'underscore'
  ], 'client');

  api.addFiles([
    'lib/transitioner.css',
    'lib/transitioner.html',
    'lib/transitioner.coffee',
  ], 'client');

  api.export('Transitioner', ['client']);

});