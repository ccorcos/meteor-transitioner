Package.describe({
  name: 'ccorcos:transitioner',
  summary: 'Page transitions integrated with Iron Router.',
  version: '1.0.0',
  git: 'https://github.com/ccorcos/meteor-transitioner'
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1');

  api.versionsFrom('velocityjs:velocityjs@1.2.1')
  api.versionsFrom('iron:router@1.0.7')
  api.use([
    'coffeescript',
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