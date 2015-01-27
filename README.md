# Iron Router Transitioner

Finally, animations between routes! This package is tightly integrated with [Iron Router](https://github.com/EventedMind/iron-router) and [VelocityJS](http://julian.com/research/velocity/).

Check out the [example app](https://github.com/ccorcos/meteor-transitioner-example).

## Getting Started

    `meteor add ccorcos:transitioner`

First you need to add Iron Router and make some routes. Then you'll need to wrap the `{{>yield}}` in your iron layout with the transitioner block helpers:

    {{#transitioner}}
      {{> yield}}
    {{/transitioner}}

Then you can specify transitions between routes using the following:

    Transitioner.transition({
        fromRoute: 'fromRouteName',
        toRoute: 'toRouteName',
        velocityAnimation: {
            in: animation,
            out: animation
        }
    })

An `animation` can be one of three things. 

1. The easiest is to pass a [VelocityJS UI Pack pre-registered effect](http://julian.com/research/velocity/#uiPack) as a string. 

2. If you want to pass options like easing or duration, you pass an array of velocity arguements.

3. You can create custom animations just like you would with `_uihooks.insertElement` and `_uihooks.removeElement`. For example:

    slideRight = 
      in: (node, next) ->
        $node = $(node)
        $.Velocity.hook($node, "translateX", "100%");
        $node.insertBefore(next)
          .velocity {translateX: ['0%', '100%']},
            duration: 500
            easing: 'ease-in-out'
            queue: false
      out: (node) ->
        $node = $(node)
        $node.velocity {translateX: '-100%'},
          duration: 500
          easing: 'ease-in-out'
          queue: false
          complete: -> 
            $node.remove()
