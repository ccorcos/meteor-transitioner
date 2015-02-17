# Iron Router Transitioner

Finally, animations between routes! This package is tightly integrated with [Iron Router](https://github.com/EventedMind/iron-router) and [VelocityJS](http://julian.com/research/velocity/).

Check out the [live demo](http://ccorcos-transitioner.meteor.com).

## To Do

- prevent the flash when force feeding. how does he register his effects?
- Expand the set of animations with Velocity.RegisterEffect
- Create a new demo with a dropdown menu of effects
- Support default animation
- How to handle iron router `waitOn`?

## Getting Started

    meteor add ccorcos:transitioner

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

1. The easiest is to pass a [VelocityJS UI Pack pre-registered effect](http://julian.com/research/velocity/#uiPack) as a string. For example, 'transition.swoopIn', 'transition.whirlOut', 'transition.slideLeftIn', etc. [A you can find a demo of these effects in the dropdown of the "Effects: Pre-Registered" section](http://julian.com/research/velocity/#uiPack). [You can also check out the source to see how to register your own effects](https://github.com/julianshapiro/velocity/blob/master/velocity.ui.js#L299). For example:

        $.Velocity.RegisterEffect 'transition.pushLeftIn', 
          defaultDuration: 500,
          calls: [
            [{translateX: ['0%', '-100%'], translateZ: 0, easing: "ease-in-out", opacity: [1, 1]}]
          ]

    Setting `translateZ` enforces GPU usage and the `opacity: [1, 1]` dummy variable [prevents a flash at the beginning of the animation](https://github.com/julianshapiro/velocity/issues/422#issuecomment-74593585).

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

You can also set a default animation between all routes using `Transitioner.defualt`. For example:

    Transitioner.default
      in: 'transition.fadeIn'
      out: 'transition.fadeOut'

## Recommendations

Build your app such that every page has it's own self-contained style. You'll also need every div up to your transitioner to have a specified height and width, typically 100%.