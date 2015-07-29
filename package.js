Package.describe({
  name: 'ccorcos:transitioner',
  summary: 'Page transitions integrated with Iron Router.',
  version: '2.0.2',
  git: 'https://github.com/ccorcos/meteor-transitioner'
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1');

  api.use([
    'velocityjs:velocityjs@1.2.0',
    'iron:router@1.0.0',
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